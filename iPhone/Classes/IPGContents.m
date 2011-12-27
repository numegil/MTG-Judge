//
//  CompRulesContents.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/27/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "IPGContents.h"
#import "IPGSubContents.h"


@implementation IPGContents

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
	
	self.title = @"IPG";

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

		// Configure the cell.
		switch(indexPath.row)
		{
			case 0: [cell.textLabel setText:@"Judging at Regular REL"]; break;
			case 1: [cell.textLabel setText:@"1 - General Philosophy"]; break;
			case 2: [cell.textLabel setText:@"3 - Game Play Errors"]; break;
			case 3: [cell.textLabel setText:@"4 - Tournament Errors"]; break;
			case 4: [cell.textLabel setText:@"5 - Unsporting Conduct"]; break;
			case 5: [cell.textLabel setText:@"6 - Cheating"]; break;
				
			default: [cell.textLabel setText:@"SHOULD NEVER HAPPEN"]; break;
		}		
		
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
	}

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
	IPGSubContents *anotherViewController = [[IPGSubContents alloc] init];
	
	int ind = indexPath.row;
	if(ind >= 2) ind++;
	[anotherViewController setIndex:ind];
	
	switch(indexPath.row)
	{
		case 0: anotherViewController.title = @"Judging at Regular REL"; break;
		case 1: anotherViewController.title = @"1 - General Philosophy"; break;
		case 2: anotherViewController.title = @"3 - Game Play Errors"; break;
		case 3: anotherViewController.title = @"4 - Tournament Errors"; break;
		case 4: anotherViewController.title = @"5 - Unsporting Conduct"; break;
		case 5: anotherViewController.title = @"6 - Cheating"; break;
			
		default: anotherViewController.title = @"Error!";
	}
	
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

