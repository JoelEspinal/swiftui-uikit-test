//
//  ContactListViewController.m
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewController.h"

@interface ContactListViewController : UIViewController

// This will hold the reference to your child table view
@property (nonatomic, strong) ContactTableViewController *embeddedTableVC;

@end

@implementation ContactListViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    // 1. Check if this is the embed segue we named in Step 1
    if ([segue.identifier isEqualToString:@"embedTableView"]) {
        
        // 2. Safely grab the destination view controller and cast it to your custom class
        self.embeddedTableVC = (ContactTableViewController *)segue.destinationViewController;
        
        NSLog(@"Successfully connected Main View Controller to Table View Controller in code!");
        
        // 3. (Optional) If you have a contacts array ready in your Main VC,
        // you can instantly pass it down to the table view right here:
        // self.embeddedTableVC.contacts = self.contacts;
    }
}

@end
