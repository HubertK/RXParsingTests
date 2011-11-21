//
//  RXDetailViewController.h
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMXMLDocument.h"

@interface RXDetailViewController : UIViewController <UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *suggestionsTable;
@property (strong, nonatomic) NSString *searchQuery;
@property (strong, nonatomic) NSMutableArray *sugArray;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
- (IBAction)beginSearch:(id)sender;
- (IBAction)SearchTextValueChanged:(id)sender;
- (void)loadSuggestions:(NSString *)spelling;

@end
