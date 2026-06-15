//
//  ContactTableViewController.h
//  Contact List
//
//  Created by Joel Espinal on 12/6/26.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// UITableView outlet – required since we inherit UIViewController, not UITableViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// Read-only count so callers can guard against an empty list
@property (nonatomic, readonly) NSInteger contactsCount;

// Bulk-delete API — called by ContactListViewController nav bar buttons
- (void)enterBulkDeleteMode;
- (void)exitBulkDeleteMode;
- (void)deleteSelectedContacts;

// Search — called by ContactListViewController search bar
- (void)filterWithQuery:(NSString *)query;
- (void)clearFilter;

- (void)tapContactDetails:(id)sender;


@end
