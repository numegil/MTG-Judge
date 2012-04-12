//
//  CompRulesContents.m
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "CompRulesContents.h"
#import "CompRulesSubContents.h"
#import "CompRulesDetails.h"
#import "CompRulesSpecific.h"

@implementation CompRulesContents

@synthesize CompRulesArray;
@synthesize CompRulesFull;
@synthesize CompRulesGlossary;
@synthesize masterBaseTableView;
@synthesize typeOfSearchControl;
@synthesize toolbar;
@synthesize searchResultsIndexes;
@synthesize searchResults;
@synthesize lastSearchString;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Comp. Rules";
	
	toolbar.hidden = TRUE;
	searching = false;
	searchingForGlossary = true;
	self.searchResults = [NSMutableArray array];
	self.searchResultsIndexes = [NSMutableArray array];
	self.lastSearchString = [NSString stringWithString:@""];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *RulesPath = [documentsDirectory stringByAppendingString:@"/CompRulesContents.txt"];
	
	NSString *tempRules = [NSString stringWithContentsOfFile:RulesPath];
	
	self.CompRulesArray = [tempRules componentsSeparatedByString:@"\n"];
	
	NSString *RulesPath2 = [documentsDirectory stringByAppendingString:@"/CompRules.txt"];
	NSString *RulesPath3 = [documentsDirectory stringByAppendingString:@"/CompRulesGlossary.txt"];
	
	NSStringEncoding encoding = 1;
	NSString *tempRules2 = [NSString stringWithContentsOfFile:RulesPath2 usedEncoding:&encoding error:NULL];
	NSString *tempRules3 = [NSString stringWithContentsOfFile:RulesPath3 usedEncoding:&encoding error:NULL];
	
	self.CompRulesFull = [tempRules2 componentsSeparatedByString:@"\n"];
	self.CompRulesGlossary = [tempRules3 componentsSeparatedByString:@"\n\n"];
	
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 415)];
	
	//Add the search bar
	sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,45)];
	sBar.delegate = self;
	
	// Set the return key and keyboard appearance of the search bar
	for (UIView *searchBarSubview in [sBar subviews]) {
		
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			
			@try {
				
				//[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDefault];
				//[(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
			}
			@catch (NSException * e) {
				
				// ignore exception
			}
		}
	}	
	
	[self.view addSubview:sBar];
	//masterBaseTableView.tableHeaderView = sBar;
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(NSString *) getSectionName:(int)section
{
	if(section == 10) return @"Glossary";
	
	NSString *targetSection = [NSString stringWithFormat:@"%d. ",section];
	
	for(int i = 0; i < [CompRulesArray count]; i++)
	{
		if( [[CompRulesArray objectAtIndex:i] rangeOfString:targetSection options:NSAnchoredSearch].location != NSNotFound)
		{
			return [CompRulesArray objectAtIndex:i];
		}
	}
    
    return NULL;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!searching) return 10;
	else return [searchResults count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	if(!searching)
	{
		if(indexPath.row == 9) [cell.textLabel setText:@"Glossary"];
		else [cell.textLabel setText:[self getSectionName:indexPath.row+1]];
	}
	else
	{
		if(indexPath.row < [searchResults count]) [cell.textLabel setText:[searchResults objectAtIndex:indexPath.row]];
		else [cell.textLabel setText:@""];
	}
	
	
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	
	//}
    
    // Set up the cell...
	
	
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
	
	if(!searching)
	{
		self.navigationItem.backBarButtonItem =
		[[UIBarButtonItem alloc] initWithTitle:@"Back"
										 style: UIBarButtonItemStyleBordered
										target:nil
										action:nil];
		
		// Navigation logic may go here -- for example, create and push another view controller.
		CompRulesSubContents *anotherViewController = [[CompRulesSubContents alloc] init];
		
		[anotherViewController setIndex:indexPath.row+1];
		
		anotherViewController.title = [self getSectionName:indexPath.row+1];
		
		[self.navigationController pushViewController:anotherViewController animated:YES];
		
		[anotherViewController release];
	}
	
	else
	{
		if(searchingForGlossary)
		{
			UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
			self.navigationItem.backBarButtonItem = backButton;
			
			// Navigation logic may go here -- for example, create and push another view controller.
			CompRulesDetails *anotherViewController = [[CompRulesDetails alloc] init];
			
			[anotherViewController setRoot:10 sub:[[searchResultsIndexes objectAtIndex:indexPath.row] intValue] stop:@"Useless"];
			
			anotherViewController.title = [searchResults objectAtIndex:indexPath.row];
			
			[self.navigationController pushViewController:anotherViewController animated:YES];
			
			[anotherViewController hideNavigationUponLeaving];
			
			[anotherViewController release];
			
			
			[self.navigationController setNavigationBarHidden:NO animated:NO];
			
		}
		
		else
		{
			UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
			self.navigationItem.backBarButtonItem = backButton;
			
			// Navigation logic may go here -- for example, create and push another view controller.
			CompRulesSpecific *anotherViewController = [[CompRulesSpecific alloc] init];
			
			[anotherViewController setTarget:[searchResultsIndexes objectAtIndex:indexPath.row]];
			
			NSString *theTitle = @"Rule ";
			theTitle = [theTitle stringByAppendingString:[searchResultsIndexes objectAtIndex:indexPath.row]];
			anotherViewController.title = theTitle;
			
			[self.navigationController pushViewController:anotherViewController animated:YES];
			
			[anotherViewController hideNavigationUponLeaving];
			
			[anotherViewController release];
			
			
			[self.navigationController setNavigationBarHidden:NO animated:NO];			
		}
		
	}
	
	
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	
	searching = true;
	
	// only show the status bar’s cancel button while in edit mode
	sBar.showsCancelButton = YES;
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
	//[tableData addObjectsFromArray:oracle];
	
	//NSUInteger indexes[] = {0,0};
	//indexes[1] = [masterBaseTableView indexPathForRowAtPoint:CGPointMake(0,0)];
	[masterBaseTableView scrollToRowAtIndexPath:[masterBaseTableView indexPathForRowAtPoint:CGPointMake(0, 0)] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	
	
	
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[masterBaseTableView setFrame:CGRectMake(0, 45+44, 320, 415-44-55)];
	
	toolbar.hidden = FALSE;
	
	[masterBaseTableView reloadData];
	//searching = true;
	
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	//[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 200)];
	//searching = false;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{	
	[self searchFor:searchText];
}

-(void)searchFor:(NSString *)searchText
{	
	lastSearchString = [NSString stringWithString:searchText];
	
	if(searchingForGlossary) // mode set to glossary entries
	{
		[searchResults removeAllObjects];
		[searchResultsIndexes removeAllObjects];
		
		NSRange textRange;
		for(int i = 0; i < [CompRulesGlossary count]; i++)
		{
			textRange =[[CompRulesGlossary objectAtIndex:i] rangeOfString:searchText options:1];
			if(textRange.location != NSNotFound)
			{
				NSArray *obj = [[CompRulesGlossary objectAtIndex:i] componentsSeparatedByString:@"\n"];
				if([obj count] > 0){
					[searchResults addObject:[obj objectAtIndex:0]];
					NSNumber *nsInt = [NSNumber numberWithInt:i];
					[searchResultsIndexes addObject:nsInt];
				}
			}
		}
	}
	else
	{
		[searchResults removeAllObjects];
		[searchResultsIndexes removeAllObjects];
		
		NSRange textRange;
		NSRange tr2;
		for(int i = 0; i < [CompRulesFull count]; i++)
		{
			textRange =[[CompRulesFull objectAtIndex:i] rangeOfString:searchText options:1];
			if(textRange.location != NSNotFound)
			{
				NSArray *obj = [[CompRulesFull objectAtIndex:i] componentsSeparatedByString:@" "];
				if([obj count] > 0){
					NSString *str0 = [obj objectAtIndex:0];
					if([str0 length] < 3) continue;
                    
                    // If the rule number has a second dot, delete it (e.g. "107.4." becomes "107.4")
                    // Assuming that the second dot is always at the end, dunno how safe that assumption is.
                    if ([[str0 componentsSeparatedByString:@"."] count] > 2)
                    {
                        str0 = [str0 substringToIndex:[str0 length]-1];
                    }
                    
					NSString *num = [[[[obj objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0] substringFromIndex:0];
					NSString *str = [str0 stringByAppendingString:@" - "];
					
					NSString *name = [self getSectionName:[num intValue]];
                    
                    if (name == NULL)
                        continue;
                    
					tr2 = [name rangeOfString:@". "];
					name = [name substringFromIndex:tr2.location+2];
					str = [str stringByAppendingString:name];
					
					[searchResults addObject:str];
					[searchResultsIndexes addObject:str0];
				}
			}
		}		
	}

	
	[masterBaseTableView reloadData];
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	/*
	 [tableData removeAllObjects];
	 [tableData addObjectsFromArray:oracle];
	 @try{
	 [masterBaseTableView reloadData];
	 }
	 @catch(NSException *e){
	 }
	 [sBar resignFirstResponder];
	 sBar.text = @"";
	 */
	
	searching = false;
	
	sBar.showsCancelButton = NO;
	[sBar setText:@""];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 320)];
	
	toolbar.hidden = TRUE;
	[masterBaseTableView reloadData];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//if(!searching) return;
	
	[sBar resignFirstResponder];
	
	// re-enable cancel button
	for (id subview in [sBar subviews]) {
		if ([subview isKindOfClass:[UIButton class]]) {
			[subview setEnabled:TRUE];
		}
	}  
	
	//[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
}

-(IBAction) switchFlipped
{
	searchingForGlossary = ([typeOfSearchControl selectedSegmentIndex] == 0);
	
	[self searchFor:[sBar text]];
}

/*
 - (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
 {
 [sBar resignFirstResponder];
 //[masterBaseTableView setFrame:CGRectMake(0, 75, 320, 375)];
 return YES;
 }
 */



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [super dealloc];
}


@end

