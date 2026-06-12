//
//  ContactTableViewController.m
//  Contact List
//
//  Created by Joel Espinal on 12/6/26.
//



#import "ContactTableViewController.h"
#import "Contact_List-Swift.h"

@interface ContactTableViewController () <UISearchBarDelegate>
// Master list from Core Data
@property (nonatomic, strong) NSArray<ContactMO *> *contacts;
// Filtered subset shown while searching
@property (nonatomic, strong) NSArray<ContactMO *> *filteredContacts;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearching;
@end



@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    // Build search bar — shown only when contacts exist (set as tableHeaderView)
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Buscar por nombre, apellido...";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar sizeToFit];

    [self fetchContactsFromCoreData];

    // Listen for new contacts saved from the SwiftUI form
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onContactSaved:)
                                                 name:@"ContactSaved"
                                               object:nil];
}

- (void)onContactSaved:(NSNotification *)notification {
    // Runs as soon as ContactViewModel posts — sheet may still be animating closed
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchContactsFromCoreData];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchContactsFromCoreData];
}

// Call this in viewDidLoad AND every time the view reappears (viewWillAppear)
- (void)fetchContactsFromCoreData {
    // 1. Get the shared context from our Swift manager
    NSManagedObjectContext *context = [CoreDataManager shared].context;

    // 2. Fetch request sorted alphabetically
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ContactMO"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // 3. Execute
    NSError *error = nil;
    self.contacts = [context executeFetchRequest:fetchRequest error:&error];

    if (error) {
        NSLog(@"Error fetching data: %@", error.localizedDescription);
        return;
    }

    // 4. Show search bar only when there are contacts
    self.tableView.tableHeaderView = (self.contacts.count > 0) ? self.searchBar : nil;

    // 5. If a search was active, reapply it; otherwise clear
    if (self.isSearching && self.searchBar.text.length > 0) {
        [self applyFilter:self.searchBar.text];
    } else {
        self.isSearching = NO;
        self.filteredContacts = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Bulk Delete
- (void)enterBulkDeleteMode {
    [self.tableView setEditing:YES animated:YES];
}

- (void)exitBulkDeleteMode {
    [self.tableView setEditing:NO animated:YES];
}

- (void)deleteSelectedContacts {
    NSArray<NSIndexPath *> *selectedPaths = [self.tableView indexPathsForSelectedRows];
    if (selectedPaths.count == 0) {
        [self.tableView setEditing:NO animated:YES];
        return;
    }

    // Sort descending so removing by index doesn't shift remaining rows
    NSArray<NSIndexPath *> *sorted = [selectedPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *a, NSIndexPath *b) {
        return b.row - a.row;
    }];

    NSManagedObjectContext *context = [CoreDataManager shared].context;
    NSMutableArray *mutableContacts = [self.contacts mutableCopy];

    for (NSIndexPath *indexPath in sorted) {
        [context deleteObject:self.contacts[indexPath.row]];
        [mutableContacts removeObjectAtIndex:indexPath.row];
    }

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error deleting contacts: %@", error.localizedDescription);
        return;
    }

    self.contacts = [mutableContacts copy];
    [self.tableView deleteRowsAtIndexPaths:selectedPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView setEditing:NO animated:YES];
}

- (NSInteger)contactsCount {
    return (NSInteger)self.contacts.count;
}

// Returns the list currently displayed (filtered or full)
- (NSArray<ContactMO *> *)activeContacts {
    return self.isSearching ? self.filteredContacts : self.contacts;
}

// Filters self.contacts and reloads the table
- (void)applyFilter:(NSString *)query {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
        @"name CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@ OR imageUrl CONTAINS[cd] %@",
        query, query, query];
    self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearching = NO;
        self.filteredContacts = nil;
    } else {
        self.isSearching = YES;
        [self applyFilter:searchText];
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.isSearching = NO;
    self.filteredContacts = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Data Source Mapping
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];

    ContactMO *contact = self.activeContacts[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.name, contact.lastName];
    cell.detailTextLabel.text = contact.phone;

    return cell;
}

#pragma mark - Swipe to Delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ContactMO *contactToDelete = self.activeContacts[indexPath.row];

        NSManagedObjectContext *context = [CoreDataManager shared].context;
        [context deleteObject:contactToDelete];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error deleting contact: %@", error.localizedDescription);
            return;
        }

        // Remove from master list
        NSMutableArray *mutable = [self.contacts mutableCopy];
        [mutable removeObject:contactToDelete];
        self.contacts = [mutable copy];

        // If filtering, also remove from filtered list
        if (self.isSearching) {
            NSMutableArray *mutableFiltered = [self.filteredContacts mutableCopy];
            [mutableFiltered removeObject:contactToDelete];
            self.filteredContacts = [mutableFiltered copy];
        }

        // Hide search bar if no contacts remain
        if (self.contacts.count == 0) {
            self.isSearching = NO;
            self.searchBar.text = @"";
            self.tableView.tableHeaderView = nil;
        }

        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end


