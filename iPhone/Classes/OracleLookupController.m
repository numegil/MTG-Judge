//
//  FirstViewController.m
//  Editor
//
//  Created by Alexei Gousev on 3/31/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import "OracleLookupController.h"
#import "OracleDetailController.h"

@implementation OracleLookupController

@synthesize masterBaseTableView;
@synthesize oracle;
@synthesize oracleData;
@synthesize triggers;
@synthesize tableData;
@synthesize lastSearchString;

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
    
	// load triggers stuff
	NSString *triggersFile = [documentsDirectory stringByAppendingString:@"/triggers.array"];
	self.triggers = [NSArray arrayWithContentsOfFile:triggersFile];
	if(triggers == nil)
		NSLog(@"ERROR!  Could not load trigger file.  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #13)");
    
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
	
	sBar.hidden = FALSE;
	masterBaseTableView.hidden = FALSE;
	
	self.lastSearchString = [NSString stringWithString:@""];
	
}

-(NSMutableArray *) lookup:(NSString *)target
{
	BOOL found = false;
    
    // output array - [card name, oracle, triggers, set info]
	NSMutableArray *output = [NSMutableArray array];
	
    // Initialize output to empty strings.
    for(int i = 0; i < 4; i++)
        [output addObject:[NSString stringWithString:@""]];
    
    // Empty input string
	if( [target length] == 0)
    {
        [output replaceObjectAtIndex:1 withObject:[NSString stringWithString:@"ERROR: Null card name!  ERROR!  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #42)"]];
        
        return output;
    }
	
	int firstLetter = [target characterAtIndex:0] - 65;
	
    // Load oracle data from file if necessary
	if([[oracleData objectAtIndex:firstLetter] count] == 0)
	{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
		NSString *fileName = [documentsDirectory stringByAppendingFormat:@"/oracle_%d.array",firstLetter];
		NSMutableArray *newArray = [NSMutableArray arrayWithContentsOfFile:fileName];
        
        if(newArray == nil)
        {
            NSLog(@"Failed to load oracle file!");
        }
        
		[oracleData replaceObjectAtIndex:firstLetter withObject:newArray];
	}
	
    // Iterate through oracle array looking for our card.
	for(int i = 0; i < [[oracleData objectAtIndex:firstLetter] count]; i++)
	{
        // Found our card!
		if([[[[oracleData objectAtIndex:firstLetter] objectAtIndex:i] objectAtIndex:0] caseInsensitiveCompare:target] == 0)
		{
			found = true;
			NSMutableArray *card = [[oracleData objectAtIndex:firstLetter] objectAtIndex:i];
			
			BOOL land = false;			
			if([card count] == 5) land = true;
			
            NSString *oracleText = [NSString stringWithString:[card objectAtIndex:0]];
            
            // Save card name
            [output replaceObjectAtIndex:0 withObject:[NSString stringWithString:[card objectAtIndex:0]]];
            
			oracleText = [oracleText stringByAppendingString:@" "];
			if(land) oracleText = [oracleText stringByAppendingString:@"\n"];
			oracleText = [oracleText stringByAppendingString:[card objectAtIndex:1]];
			if(!land) oracleText = [oracleText stringByAppendingString:@"\n"];
			oracleText = [oracleText stringByAppendingString:[card objectAtIndex:2]];
			oracleText = [oracleText stringByAppendingString:@"\n\n"];
			
			int tempInt = 4;
			if(land) tempInt = 3;
			oracleText = [oracleText stringByAppendingString:[card objectAtIndex:tempInt]];
			oracleText = [oracleText stringByAppendingString:@"\n\n"];
			
			tempInt = 3;
			if(land) tempInt = 2;
			oracleText = [oracleText stringByAppendingString:[card objectAtIndex:tempInt]];
			
            // Set info
			tempInt = 5;
			if(land) tempInt = 4;
            NSString *setData = [NSString stringWithString:[card objectAtIndex:tempInt]];
            NSArray *set_output_pre = [setData componentsSeparatedByString:@","];
            NSMutableArray *set_output = [NSMutableArray array];
            
            // Remove any single leading spaces from the text info
            for(int i = 0; i < [set_output_pre count]; i++)
            {
                if([[set_output_pre objectAtIndex:i] characterAtIndex:0] == ' ')
                    [set_output addObject:[[set_output_pre objectAtIndex:i] substringFromIndex:1]];
                else
                    [set_output addObject:[set_output_pre objectAtIndex:i]];
            }
            
            // See if the card has any triggers that we know about.
            NSMutableArray *triggers_output = [NSMutableArray array];
            
            for(int i = 0; i < [triggers count]; i++)
            {
                NSArray *trigger_card = [triggers objectAtIndex:i];
                
                // If the card names match up
                if([[trigger_card objectAtIndex:0] isEqualToString:[card objectAtIndex:0]])
                {
                    // Make sure we have at least one trigger
                    if([trigger_card count] < 2)
                    {
                        NSLog(@"Error!  A card in the triggers file doesn't have any triggers.");
                        continue;
                    }
                    
                    // Iterate through all the triggers of the card.
                    for(int j = 1; j < [trigger_card count]; j++)
                    {
                        NSString *count_label = @"-1";
                        switch(j)
                        {
                            case 1:
                                count_label = @"first";
                                break;
                            case 2:
                                count_label = @"second";
                                break;
                            case 3:
                                count_label = @"third";
                                break;
                            default:
                                count_label = @"fourth";
                        }
                        
                        [triggers_output addObject:[NSString stringWithFormat:@"The %@ trigger is %@.", count_label, [trigger_card objectAtIndex:j]]];
                    }
                    
                    break;
                }
            }
            
            // Insert our results into output array
            [output replaceObjectAtIndex:1 withObject:oracleText];
            [output replaceObjectAtIndex:2 withObject:triggers_output];
            [output replaceObjectAtIndex:3 withObject:set_output];
		}
	}
	
	if(found) return output;
    
	else 
    {
        [output replaceObjectAtIndex:1 withObject:@"Card not found!"];
        return output;
    }
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
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	NSString *target = [tableData objectAtIndex:indexPath.row];
    NSArray *output = [self lookup:target];
	currentCard = [NSString stringWithString:target];
    
    
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
    // Navigation logic may go here -- for example, create and push another view controller.
	OracleDetailController *anotherViewController = [[OracleDetailController alloc] init];
	
	[anotherViewController setOracle:[output objectAtIndex:1] triggers:[output objectAtIndex:2] setInfo:[output objectAtIndex:3]];
	
    anotherViewController.title = [output objectAtIndex:0];
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	
	[anotherViewController release];	
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(!searching) return;
	
	[sBar resignFirstResponder];
	[masterBaseTableView setFrame:CGRectMake(0, 45, 320, 375)];
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

// Hide 

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
