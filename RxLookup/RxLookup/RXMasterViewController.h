//
//  RXMasterViewController.h
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class RXDetailViewController;

@interface RXMasterViewController : UITableViewController

@property (strong, nonatomic) RXDetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSString *nameOfMedicine;
@end
