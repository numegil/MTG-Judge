//
//  MoreViewsController.m
//  MTGJudge
//
//  Created by Alexei Gousev on 9/10/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import "MoreViewsController.h"
#import "DecklistCounterController.h"
#import "CheckForUpdatesController.h"
#import "DraftTimer.h"

@implementation MoreViewsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"More Features";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    switch(indexPath.row)
    {
        case 0:
            [cell.textLabel setText:@"Decklist Counter"]; break;
        case 1:
            [cell.textLabel setText:@"Draft Timer"]; break;
        case 2:
            [cell.textLabel setText:@"Check for Updates"]; break;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
    if(indexPath.row == 0)
    {
        // Navigation logic may go here -- for example, create and push another view controller.
        DecklistCounterController *anotherViewController = [[DecklistCounterController alloc] init];
        
        anotherViewController.title = @"Decklist Counter";
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        
        [anotherViewController release];
        
        [self.navigationController setNavigationBarHidden:true];
    }
    
    if(indexPath.row == 2)
    {
        // Navigation logic may go here -- for example, create and push another view controller.
        CheckForUpdatesController *anotherViewController = [[CheckForUpdatesController alloc] init];
        
        anotherViewController.title = @"Update";
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        
        [anotherViewController release];
        
        //[self.navigationController setNavigationBarHidden:true];
    }
    
    if(indexPath.row == 1)
    {
        // Navigation logic may go here -- for example, create and push another view controller.
        DraftTimer *anotherViewController = [[DraftTimer alloc] init];
        
        anotherViewController.title = @"Draft Timer";
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        
        [anotherViewController release];
        
        //[self.navigationController setNavigationBarHidden:true];
    }
}

@end
