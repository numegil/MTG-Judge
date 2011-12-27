//
//  FirstViewController.m
//  Editor
//
//  Created by Alexei Gousev on 3/31/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import "OracleLookupController.h"


@implementation OracleLookupController

@synthesize masterBaseTableView;
@synthesize oracle;
@synthesize oracleData;
@synthesize oracleTextView;
@synthesize gathererPicView;
@synthesize tableData;
@synthesize lastSearchString;
@synthesize returnButton;
@synthesize gathererPicSwitch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//masterBaseTableView.delegate = self;	
	
	// load oracle names
	NSString *oracleFile = [documentsDirectory stringByAppendingString:@"/oracle_names_only.array"];
	self.oracle = [NSArray arrayWithContentsOfFile:oracleFile];
	if(oracle == nil)
		NSLog(@"ERROR!  Could not load oracle file.  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #12)");
	
	self.oracleData = [NSMutableArray array];
	for(int i = 0; i < 26; i++)
	{
		[oracleData addObject:[NSMutableArray array]];
	}
	
	//Add the search bar
	sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,45)];
	sBar.delegate = self;
	searching = false;

	// Set the return key and keyboard appearance of the search bar
	for (UIView *searchBarSubview in [sBar subviews]) {
		
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			
			@try {
				
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDefault];
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
	self.tableData = [[NSMutableArray alloc]init];
	[tableData addObjectsFromArray:oracle];//on launch it should display all the records
	
	oracleTextView.hidden = TRUE;
	sBar.hidden = FALSE;
	masterBaseTableView.hidden = FALSE;
	gathererPicMode = FALSE;
	gathererPicView.hidden = TRUE;
	gathererPicSwitch.hidden = TRUE;
	gathererPicSwitch.on = FALSE;
	
	self.lastSearchString = [NSString stringWithString:@""];
	
}

-(NSString *) lookup:(NSString *)target
{
	BOOL found = false;
	NSString *output;
	
	if( [target length] == 0) return @"ERROR: Null card name!  ERROR!  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #42)"; // blank string
	
	int firstLetter = [target characterAtIndex:0] - 65;
	
	if([[oracleData objectAtIndex:firstLetter] count] == 0)
	{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
		NSString *fileName = [documentsDirectory stringByAppendingFormat:@"/oracle_%d.array",firstLetter];
		NSMutableArray *newArray = [NSMutableArray arrayWithContentsOfFile:fileName];
		[oracleData replaceObjectAtIndex:firstLetter withObject:newArray];
	}
	
	for(int i = 0; i < [[oracleData objectAtIndex:firstLetter] count]; i++)
	{
		if([[[[oracleData objectAtIndex:firstLetter] objectAtIndex:i] objectAtIndex:0] caseInsensitiveCompare:target] == 0)
		{
			found = true;
			NSMutableArray *card = [[oracleData objectAtIndex:firstLetter] objectAtIndex:i];
			
			BOOL land = false;			
			if([card count] == 5) land = true;
			
			output = [NSString stringWithString:[card objectAtIndex:0]];
			output = [output stringByAppendingString:@" "];
			if(land) output = [output stringByAppendingString:@"\n"];
			output = [output stringByAppendingString:[card objectAtIndex:1]];
			if(!land) output = [output stringByAppendingString:@"\n"];
			output = [output stringByAppendingString:[card objectAtIndex:2]];
			output = [output stringByAppendingString:@"\n\n"];
			
			int tempInt = 4;
			if(land) tempInt = 3;
			output = [output stringByAppendingString:[card objectAtIndex:tempInt]];
			output = [output stringByAppendingString:@"\n\n"];
			
			tempInt = 3;
			if(land) tempInt = 2;
			output = [output stringByAppendingString:[card objectAtIndex:tempInt]];
			output = [output stringByAppendingString:@"\n\n"];
			
			tempInt = 5;
			if(land) tempInt = 4;
			output = [output stringByAppendingString:[card objectAtIndex:tempInt]];
		}
	}
	
	if(found) return output;
	else return @"Card not found!";
}

-(void) updatePic:(NSString*)card
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *picURL = @"http://gatherer.wizards.com/Handlers/Image.ashx?type=card&name=";
	NSString *formattedName = [card stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
	picURL = [picURL stringByAppendingString:formattedName];
	NSString *fullPath = [formattedName stringByAppendingString:@".jpg"];
    
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:fullPath];	
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if(![fm fileExistsAtPath:documentsDirectory]) // if image is not already there
	{
		NSData *DLPic = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picURL]];
		BOOL works = [DLPic writeToFile:documentsDirectory atomically:YES];
		
		[DLPic release];
	}
	
	gathererPicView.image = [UIImage imageWithContentsOfFile:documentsDirectory];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	cell.textLabel.text = [tableData objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, sedft the detail view controller's detail item to the item associated with the selected row.
     */
	NSString *target = [tableData objectAtIndex:indexPath.row];
    oracleTextView.text = [self lookup:target];
	if(gathererPicMode) [self updatePic:target];
	currentCard = [NSString stringWithString:target];
	
	masterBaseTableView.hidden = TRUE;
	if(!gathererPicMode) oracleTextView.hidden = FALSE;
	else gathererPicView.hidden = FALSE;
	sBar.hidden = TRUE;
	//gathererPicSwitch.hidden = FALSE;
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(!searching) return;
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
}

-(IBAction) switchFlipped;
{
	
	gathererPicMode = gathererPicSwitch.on;
	
	if(gathererPicMode)
	{
		[self updatePic:currentCard];
		oracleTextView.hidden = TRUE;
		gathererPicView.hidden = FALSE;
	}
	else 
	{
		oracleTextView.hidden = FALSE;
		gathererPicView.hidden = TRUE;
	}
	return;

}

///////////
///////////
///////////

- (void) returnButtonPressed
{
	masterBaseTableView.hidden = FALSE;
	oracleTextView.hidden = TRUE;
	sBar.hidden = FALSE;
	gathererPicView.hidden = TRUE;
	gathererPicSwitch.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	sBar.showsCancelButton = YES;
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
	//[tableData addObjectsFromArray:oracle];
	
	//NSUInteger indexes[] = {0,0};
	//indexes[1] = [masterBaseTableView indexPathForRowAtPoint:CGPointMake(0,0)];
	[masterBaseTableView scrollToRowAtIndexPath:[masterBaseTableView indexPathForRowAtPoint:CGPointMake(0, 0)] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	
	
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 200)];
	searching = true;
	
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
	searching = false;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{	
	// remove all data that belongs to previous search
	if([searchText isEqualToString:@""] || searchText==nil || [searchText isEqualToString:@"?"]){
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:oracle];
		[masterBaseTableView reloadData];
		self.lastSearchString = [NSString stringWithString:searchText];
		return;
	}
	
	if([searchText length] > [lastSearchString length])
	{
		BOOL anchored = ([searchText characterAtIndex:0] != '?');
		
		//anchored = false;  // Temporary (?), making '?' option the default
		
		self.lastSearchString = [NSString stringWithString:searchText];
		if(!anchored) searchText = [searchText substringFromIndex:1];
		
		int max = [tableData count];
		for(int i = 0; i < max; i++)
		{
			NSString *card = [tableData objectAtIndex:i];
			//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
			NSRange r;
			if(anchored) r = [card rangeOfString:searchText options:1];        // SET OPTIONS TO 9 FOR ANCHORED SEARCH
			else r = [card rangeOfString:searchText options:1];  //Temporary (?), making '?' option the default, set value to 9 to go back to old way
			
			if(r.location == NSNotFound)
			{
				[tableData removeObjectAtIndex:i];
				i--;
				max--;
			}
			//[pool release];
		}
		[masterBaseTableView reloadData];
		
		return;
	}
	
	[tableData removeAllObjects];
	
	BOOL anchored = ([searchText characterAtIndex:0] != '?');
	self.lastSearchString = [NSString stringWithString:searchText];
	if(!anchored) searchText = [searchText substringFromIndex:1];
	
	for(NSString *card in oracle)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		
		NSRange r;
		if(anchored) r = [card rangeOfString:searchText options:1];        // SET OPTIONS TO 9 FOR ANCHORED SEARCH
		else r = [card rangeOfString:searchText options:1];
		
		if(r.location != NSNotFound)
		{
			[tableData addObject:card];
		}
		[pool release];
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
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
	
}

/*
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
	return YES;
}
*/

@end
