//
//  ContactListViewController.m
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewController.h"
#import "Contact_List-Swift.h"

@interface ContactListViewController : UIViewController

@property (nonatomic, strong) ContactTableViewController *embeddedTableVC;
@property (nonatomic, weak) IBOutlet UINavigationBar *topNavigationBar;
@property (nonatomic, assign) BOOL isBulkDeleting;

- (IBAction)addNewContactTapped:(id)sender;
- (IBAction)borrarTapped:(id)sender;

@end

@implementation ContactListViewController

#pragma mark - Nav Actions

- (IBAction)addNewContactTapped:(id)sender {
    [ContactPresenter presentCreateContactFrom:self];
}

- (IBAction)borrarTapped:(id)sender {
    if (!self.isBulkDeleting) {
        // Guard: nothing to delete if the list is empty
        if (self.embeddedTableVC.contactsCount == 0) {
            UIAlertController *alert = [UIAlertController
                alertControllerWithTitle:@"Sin contactos"
                                 message:@"No hay contactos para borrar."
                          preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
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
}

- (void)restoreDefaultNavItems {
    UIBarButtonItem *borrarBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Borrar"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(borrarTapped:)];
    borrarBtn.tintColor = [UIColor systemRedColor];

    UIBarButtonItem *nuevoBtn = [[UIBarButtonItem alloc]
        initWithTitle:@"Nuevo"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(addNewContactTapped:)];

    self.topNavigationBar.topItem.leftBarButtonItem  = borrarBtn;
    self.topNavigationBar.topItem.rightBarButtonItem = nuevoBtn;
}

#pragma mark - Embed Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"embedTableView"]) {
        self.embeddedTableVC = (ContactTableViewController *)segue.destinationViewController;
        NSLog(@"Successfully connected Main VC to Table VC via embed segue.");
    }
}

@end
