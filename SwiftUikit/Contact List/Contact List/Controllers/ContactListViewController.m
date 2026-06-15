//
//  ContactListViewController.m
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewController.h"
#import "Contact_List-Swift.h"

@interface ContactListViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) ContactTableViewController *embeddedTableVC;
@property (nonatomic, weak) IBOutlet UINavigationBar *topNavigationBar;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isBulkDeleting;

- (IBAction)addNewContactTapped:(id)sender;
- (IBAction)borrarTapped:(id)sender;
- (IBAction)showDetails:(id)sender;

@end

@implementation ContactListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.placeholder = @"Buscar por nombre, apellido, teléfono o URL";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onContactsChanged:)
                                                 name:@"ContactSaved"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onContactsChanged:)
                                                 name:@"ContactsChanged"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSearchBarVisibility];
}

- (void)onContactsChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateSearchBarVisibility];
    });
}

- (void)updateSearchBarVisibility {
    if (!self.embeddedTableVC) {
        return;
    }

    BOOL hasContacts = self.embeddedTableVC.contactsCount > 0;
    self.searchBar.hidden = !hasContacts;

    if (!hasContacts) {
        self.searchBar.text = @"";
        [self.embeddedTableVC clearFilter];
    }

    if (!self.isBulkDeleting) {
        self.topNavigationBar.topItem.leftBarButtonItem.enabled = hasContacts;
    }
}

- (IBAction)showDetails:(id)sender {
    [ContactPresenter presentCreateContactFrom:self];
}

#pragma mark - Nav Actions

- (IBAction)addNewContactTapped:(id)sender {
   [ContactPresenter presentCreateContactFrom:self];
}

- (IBAction)borrarTapped:(id)sender {
    if (!self.isBulkDeleting) {
        [self enterBulkDeleteMode];
    } else {
        [self confirmBulkDelete];
    }
}

#pragma mark - Bulk Delete Lifecycle

- (void)enterBulkDeleteMode {
    self.isBulkDeleting = YES;
    [self.embeddedTableVC enterBulkDeleteMode];

    // Left: Cancelar (plain)
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Cancelar"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(cancelBulkDelete)];

    // Right: Borrar in red — confirms the deletion
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Borrar"
                style:UIBarButtonItemStyleDone
               target:self
               action:@selector(confirmBulkDelete)];
    confirmBtn.tintColor = [UIColor systemRedColor];

    self.topNavigationBar.topItem.leftBarButtonItem  = cancelBtn;
    self.topNavigationBar.topItem.rightBarButtonItem = confirmBtn;
}

- (void)cancelBulkDelete {
    self.isBulkDeleting = NO;
    [self.embeddedTableVC exitBulkDeleteMode];
    [self restoreDefaultNavItems];
}

- (void)confirmBulkDelete {
    [self.embeddedTableVC deleteSelectedContacts];
    self.isBulkDeleting = NO;
    [self restoreDefaultNavItems];
    [self updateSearchBarVisibility];
}

- (void)restoreDefaultNavItems {
    UIBarButtonItem *borrarBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Borrar"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(borrarTapped:)];
    borrarBtn.tintColor = [UIColor systemRedColor];
    borrarBtn.enabled = self.embeddedTableVC.contactsCount > 0;

    UIBarButtonItem *nuevoBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Nuevo"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(addNewContactTapped:)];

    self.topNavigationBar.topItem.leftBarButtonItem  = borrarBtn;
    self.topNavigationBar.topItem.rightBarButtonItem = nuevoBtn;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.embeddedTableVC clearFilter];
    } else {
        [self.embeddedTableVC filterWithQuery:searchText];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.embeddedTableVC clearFilter];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Embed Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"embedTableView"]) {
        self.embeddedTableVC = (ContactTableViewController *)segue.destinationViewController;
        [self updateSearchBarVisibility];
        NSLog(@"Successfully connected Main VC to Table VC via embed segue.");
    }
}

@end
