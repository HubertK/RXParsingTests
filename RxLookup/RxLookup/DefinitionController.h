//
//  DefinitionController.h
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefinitionController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UITextView *definitionTextView;
@property (strong, nonatomic) NSMutableArray *synonyms;
@property (strong, nonatomic) NSString *nameOfMedicine;
@property (strong, nonatomic) NSString *definitionText;;
@property (weak, nonatomic) IBOutlet UITableView *synTableView;

- (void)lookupMedicine:(NSString *)medicine;
@end
