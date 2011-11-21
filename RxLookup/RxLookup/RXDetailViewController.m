//
//  RXDetailViewController.m
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//
#define RXNormBaseURL @"http://rxnav.nlm.nih.gov/REST/drugs?name=%@"
#import "Constants.h"
#import "RXDetailViewController.h"

@interface RXDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation RXDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize searchField = _searchField;
@synthesize suggestionsTable = _suggestionsTable;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize searchQuery;
@synthesize sugArray;
@synthesize suggestionLabel = _suggestionLabel;
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.sugArray = [[NSMutableArray alloc]initWithCapacity:20];
    self.suggestionsTable.backgroundView = [[UIView alloc]init];
    self.suggestionsTable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.5];
    [self.suggestionsTable setHidden:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setSearchField:nil];
    [self setSuggestionsTable:nil];
    [self setSuggestionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)beginSearch:(id)sender {
    self.searchQuery = [NSString stringWithFormat:RXNormBaseURL,self.searchField.text];
    NSURL *RXURL = [NSURL URLWithString:self.searchQuery];
    NSData *data = [NSData dataWithContentsOfURL:RXURL];
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    NSLog(@"Document:\n %@", document);
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    SMXMLElement *items = [document.root childNamed:@"drugGroup"];
     NSLog(@"Drug Group:%@",items);
  
    for (SMXMLElement *element in [items childrenNamed:@"conceptGroup"]) {
      //  NSLog(@"\nElement:%@",element);
        NSArray *names = [element childrenNamed:@"conceptProperties"];
        for (SMXMLElement *aname in names) {
            NSLog(@"Name is %@",[aname valueWithPath:@"name"]);
            NSString *theName = [aname valueWithPath:@"name"];
            if ([theName length] > 0) {
                [nameArray addObject:theName];
            }
        }
       // NSLog(@"Names:%@",names);
       }
    NSLog(@"\nName Array:%@",nameArray);
    if ([nameArray count] <= 0) {
    
         [self loadSuggestions:self.searchField.text];
    }
    NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:nameArray,@"names",self.searchField.text,@"nameOfMedicine", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:SearchFinishedNotification object:nil userInfo:userInfo];
    [self.suggestionLabel setHidden:YES];
    [self.suggestionsTable setHidden:YES];
    [self.searchField resignFirstResponder];
}


- (IBAction)SearchTextValueChanged:(id)sender {
    NSLog(@"\nTEXT:%@",self.searchField.text);
    [self loadSuggestions:self.searchField.text];
}



- (void)loadSuggestions:(NSString *)spelling{
    [self.sugArray removeAllObjects];
    [self.suggestionsTable setHidden:NO];
    [self.suggestionLabel setHidden:NO];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        NSString *URLString = [NSString stringWithFormat:@"http://rxnav.nlm.nih.gov/REST/spellingsuggestions?name=%@",spelling];
        NSURL *URL = [NSURL URLWithString:URLString];
        NSData *data = [NSData dataWithContentsOfURL:URL];
        SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
        SMXMLElement *items = [document.root childNamed:@"suggestionGroup"];
        for (SMXMLElement *suggestion in [items childrenNamed:@"suggestionList"]) {
            NSLog(@"suggestion:%@",[suggestion valueWithPath:@"suggestion"]); 
            
            NSArray *array = [[suggestion childrenNamed:@"suggestion"]valueForKey:@"value"];
            NSLog(@"array %@",array);
            self.sugArray = [array mutableCopy];
        }
        

        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            [self.suggestionsTable reloadData];

        });
    });
        
   
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [sugArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [sugArray objectAtIndex:indexPath.row];
   
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchField.text = [self.sugArray objectAtIndex:indexPath.row];
    [self.suggestionLabel setHidden:YES];
    [self.suggestionsTable setHidden:YES];
    [self.searchField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}








@end
