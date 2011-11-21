//
//  DefinitionController.m
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "DefinitionController.h"
#import "SMXMLDocument.h"

@implementation DefinitionController
@synthesize synTableView;
@synthesize nameLabel;

@synthesize definitionTextView;
@synthesize synonyms,nameOfMedicine,definitionText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.synonyms = [[NSMutableArray alloc]init];
    self.nameLabel.text = self.nameOfMedicine;
    [self lookupMedicine:self.nameOfMedicine];
    [super viewDidLoad];
}
- (void)lookupMedicine:(NSString *)medicine{
    NSString *URLString = [NSString stringWithFormat:@"http://demo.api.fingerprint.md/concept/%@",medicine];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    
    for (SMXMLElement *item in [document.root childrenNamed:@"ConceptInfo"] ) {
        NSLog(@"item:%@",item);
        self.definitionTextView.text = [item valueWithPath:@"Definition"];
        self.synonyms = [[[item childNamed:@"Synonyms"].children valueForKey:@"value"]mutableCopy]; 
    }
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDefinitionTextView:nil];
    
    [self setSynTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.synonyms count];;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [synonyms objectAtIndex:indexPath.row];
    return cell;
}















@end
