//
//  CompRulesSubContents.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/28/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "IPGSubContents.h"
#import "IPGDetailMenu.h"
#import "IPGDetail.h"


@implementation IPGSubContents


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

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    
	switch(index)
	{
		case 0: return 5; break;
		case 1: return 4; break;
		case 3: return 8; break;
		case 4: return 10; break;
		case 5: return 7; break;
		case 6: return 5; break;
		
	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:[self getText:indexPath.row]];
	
	
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
    // Set up the cell...
    
    return cell;
}

-(NSString *) getText:(int) indexPath
{
    
	switch(index)
	{
		case 0:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Common Errors"; break;
			case 2: return @"General Unwanted Behaviours"; break;
			case 3: return @"Serious Problems"; break;
			case 4: return @"Resources"; break;
				
		}
			break;
				
		case 1:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Definition of REL"; break;
			case 2: return @"Definition of Penalties"; break;
			case 3: return @"Applying Penalties"; break;

		}
			break;
		case 3:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Missed Trigger"; break;
			case 2: return @"Failure to Reveal"; break;
			case 3: return @"Looking at Extra Cards"; break;
			case 4: return @"Drawing Extra Cards"; break;
			case 5: return @"Improper Drawing at Start of Game"; break;
			case 6: return @"Game Rule Violation"; break;
			case 7: return @"Failure to Maintain Game State"; break;
				
		}
			break;	
			
		case 4:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Tardiness"; break;
			case 2: return @"Outside Assistance"; break;
			case 3: return @"Slow Play"; break;
			case 4: return @"Insufficient Shuffling"; break;
			case 5: return @"Failure to Follow Official Announcements"; break;
			case 6: return @"Draft Procedure Violation"; break;
			case 7: return @"Player Communication Violation"; break;
			case 8: return @"Marked Cards"; break;
			case 9: return @"Deck/Decklist Problem"; break;
				
		}
			break;
			
		case 5:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Unsporting Conduct - Minor"; break;
			case 2: return @"Unsporting Conduct - Major"; break;
			case 3: return @"Improperly Determining a Winner"; break;
			case 4: return @"Bribery and Wagering"; break;
			case 5: return @"Aggressive Behavior"; break;
			case 6: return @"Theft of Tournament Material"; break;
				
		}
		break;
			
		case 6:
			switch(indexPath)
		{
			case 0: return @"Introduction"; break;
			case 1: return @"Stalling"; break;
			case 2: return @"Fraud"; break;
			case 3: return @"Hidden Information Violation"; break;
			case 4: return @"Manipulation of Game Materials"; break;				
		}
		break;
	}
	
	return @"Error!";
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
	if(index == 0) // FCE
	{
		IPGDetail *anotherViewController = [[IPGDetail alloc] init];
		[anotherViewController setRoot:index sub:indexPath.row opt:-1 stop:[NSString stringWithFormat:@"Stop - %d",indexPath.row+1]];
		anotherViewController.title = [self getText:indexPath.row];
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];					
	}
	else if(index == 1) // General Philosophy
	{
		IPGDetail *anotherViewController = [[IPGDetail alloc] init];
		[anotherViewController setRoot:index sub:indexPath.row opt:-1 stop:[NSString stringWithFormat:@"Stop - %d",indexPath.row+1]];
		anotherViewController.title = [self getText:indexPath.row];
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];				
	}
	else if(indexPath.row == 0) // Introduction section
	{
		IPGDetail *anotherViewController = [[IPGDetail alloc] init];
		[anotherViewController setRoot:index sub:indexPath.row opt:-1 stop:[NSString stringWithFormat:@"%d.1",index]];
		anotherViewController.title = [self getText:indexPath.row];
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];			
	}
	else
	{
		IPGDetailMenu *anotherViewController = [[IPGDetailMenu alloc] init];
		[anotherViewController setRoot:index setSubRoot:indexPath.row];
		anotherViewController.title = [self getText:indexPath.row];
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];
	}
	
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

