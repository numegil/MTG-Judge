//
//  CompRulesSubContents.m
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "CompRulesSubContents.h"
#import "CompRulesDetails.h"


@implementation CompRulesSubContents

@synthesize CompRulesArray;


-(void) setIndex:(int)indx
{
	index = indx;
}

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
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
	NSString *RulesPath = [documentsDirectory stringByAppendingString:@"/CompRulesContents.txt"];
	if(index == 10) RulesPath = [documentsDirectory stringByAppendingString:@"/CompRulesGlossary.txt"];
	
	NSString *tempRules = [NSString stringWithContentsOfFile:RulesPath];
	
	self.CompRulesArray = [tempRules componentsSeparatedByString:@"\n"];
	
	if(index != 10) // not glossary
	{
		numElements = 0;
		NSString *target = [NSString stringWithFormat:@"%d. ",index];
		BOOL found = false;

		for(int i = 0; i < [CompRulesArray count]; i++)
		{
			if(found)
            {
                NSString *stopHere = [NSString stringWithString:[CompRulesArray objectAtIndex:i]];
                if([stopHere isEqualToString:@"\r"] || [stopHere isEqualToString:@""]) break;
            }
			if( [[CompRulesArray objectAtIndex:i] rangeOfString:target options:NSAnchoredSearch].location != NSNotFound)
				found = true;
			else if(found) numElements++;
		}
		//numElements--;
	}
	else // glossary
	{
		numElements = 0;
		for(int i = 0; i < [CompRulesArray count]; i++)
		{
			NSString *tempString = [CompRulesArray objectAtIndex:i];
			//if([tempString rangeOfString:@"" options:NSLiteralSearch].location != NSNotFound)
			if([tempString length] <= 1)
				numElements++;
		}
        numElements--;	
	}
		   

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *) getSubtext:(int)indx
{
	if(index != 10) // not glossary
	{
		NSString *targetSection = [NSString stringWithFormat:@"%d. ",100*index + indx-1];
		
		for(int i = 0; i < [CompRulesArray count]; i++)
		{
			if( [[CompRulesArray objectAtIndex:i] rangeOfString:targetSection options:NSAnchoredSearch].location != NSNotFound)
			{
				return [CompRulesArray objectAtIndex:i];
			}
		}
		
		return @"ERROR!  Something went wrong.  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #23)";
	}
	else
	{
		NSString *tempString;
		int arrayIndex = 0;
		
		for(int i = 0; i < indx; i++)
		{
			tempString = [CompRulesArray objectAtIndex:arrayIndex];
			while([tempString length] > 1)
			{
				if(arrayIndex+1 >= [CompRulesArray count]) break;
				arrayIndex++;
				tempString = [CompRulesArray objectAtIndex:arrayIndex];
			}
			arrayIndex++;
		}
		return [CompRulesArray objectAtIndex:arrayIndex];
	}
	
}

-(NSString *) getSectionName:(int)section
{
	NSString *targetSection = [NSString stringWithFormat:@"%d. ",section];
	
	for(int i = 0; i < [CompRulesArray count]; i++)
	{
		if( [[CompRulesArray objectAtIndex:i] rangeOfString:targetSection options:NSAnchoredSearch].location != NSNotFound)
		{
			return [CompRulesArray objectAtIndex:i];
		}
	}
	
	return @"ERROR!  Something went wrong.  Please email me at MTGJudgeBugs@gmail.com to submit a bug report. (Error ID #18)";
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
    return numElements;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];		
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		
	}

	
	[cell.textLabel setText:[self getSubtext:indexPath.row+1]];
	
    // Set up the cell...
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
	
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
    // Navigation logic may go here -- for example, create and push another view controller.
	CompRulesDetails *anotherViewController = [[CompRulesDetails alloc] init];
	
	if(index == 10) [anotherViewController setRoot:index sub:indexPath.row+1 stop:@"Useless"];
	else [anotherViewController setRoot:index sub:indexPath.row+1 stop:[self getSubtext:indexPath.row+2]];
	
	if(indexPath.row >= numElements-1)
	{
		NSString *stopDisplaying;
		if(index != 10)
		{
			stopDisplaying = [self getSectionName:index+1];
			//NSString *nl = @"\n";
			//stopDisplaying = [nl stringByAppendingString:stopDisplaying];
		}
		[anotherViewController setRoot:index sub:indexPath.row+1 stop:stopDisplaying];
	}
	
	anotherViewController.title = [self getSubtext:indexPath.row+1];
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	
	[anotherViewController release];	
	
}

-(void) openRule:(int)indx with:(int)indx2
{
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
    // Navigation logic may go here -- for example, create and push another view controller.
	CompRulesDetails *anotherViewController = [[CompRulesDetails alloc] init];
	
	if(indx == 10) [anotherViewController setRoot:indx sub:indx2+1 stop:@"Useless"];
	else [anotherViewController setRoot:indx sub:indx2+1 stop:[self getSubtext:indx2+2]];
	
	if(indx2 >= numElements-1)
	{
		NSString *stopDisplaying;
		if(index != 10)
		{
			stopDisplaying = [self getSectionName:indx+1];
			//NSString *nl = @"\n";
			//stopDisplaying = [nl stringByAppendingString:stopDisplaying];
		}
		[anotherViewController setRoot:indx sub:indx2+1 stop:stopDisplaying];
	}
	
	anotherViewController.title = [self getSubtext:indx2+1];
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	
	[anotherViewController release];	
	
}


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

