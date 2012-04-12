//
//  RootViewController.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import "QuickReferenceController.h"
#import "QuickReferenceDetailController.h"
#import "BannedFormatList.h"
#import "CheckForUpdatesController.h"
#import <QuartzCore/CALayer.h>
#import <Foundation/NSObject.h>


@implementation QuickReferenceController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Quick Ref.";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
    //[self performSelectorInBackground:@selector(checkForNewFiles) withObject:nil];
    
    [self copyResourcesToDocuments];
    
	[self checkForNewFiles];
}

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
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
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
			case 0: [cell.textLabel setText:@"Penalties"]; break;
			case 1: [cell.textLabel setText:@"Lapsing Triggers"]; break;
			case 2: [cell.textLabel setText:@"Layers / Casting Spells"]; break;
			case 3: [cell.textLabel setText:@"Resolving Spells / Copiable Characteristics"]; break;
			case 4: [cell.textLabel setText:@"Types of Information"]; break;
			case 5: [cell.textLabel setText:@"Head Judge Announcement"]; break;
			case 6: [cell.textLabel setText:@"Reviews / Feedback"]; break;
            case 7: [cell.textLabel setText:@"Banned Lists by Format"]; break;
				
			default: [cell.textLabel setText:@"Error!"]; break;
		}
		
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
				
    }
	
    return cell;
}




// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
    if(indexPath.row < 7)
    {
        // Navigation logic may go here -- for example, create and push another view controller.
        QuickReferenceDetailController *anotherViewController = [[QuickReferenceDetailController alloc] init];
        
        [anotherViewController setIndex:indexPath.row];
        anotherViewController.title = @"Quick Reference";
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        
        [anotherViewController release];
    }
    else
    {
        // Navigation logic may go here -- for example, create and push another view controller.
        BannedFormatList *anotherViewController = [[BannedFormatList alloc] init];
        
        anotherViewController.title = @"Formats";
        
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

// The app reads it's data files from the Documents directory.  This way, we can overwrite the data files without re-deploying the entire app.
-(bool) copyResourcesToDocuments
{
    // The first time an app runs per version, we want to overwrite the files.
    bool forceOverwrite = false;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *previousVersion = [defaults stringForKey:@"previous_version"];
    
    if(previousVersion == nil || ![previousVersion isEqualToString:version])
    {
        forceOverwrite = true;
        [defaults setObject:version forKey:@"previous_version"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *vcPath = [[NSBundle mainBundle] pathForResource:@"version_control" ofType:@"array"];
    NSMutableArray *resources = [NSMutableArray arrayWithContentsOfFile:vcPath];
    
    // Make sure we also handle version_control.array itself
    NSArray *temp = [NSArray arrayWithObject:[NSString stringWithString:@"version_control.array"]];
    [resources addObject:temp];
    
    BOOL success;
    
    for(NSArray *vc_element in resources)
    {
        NSString *filename = [vc_element objectAtIndex:0];
        
        NSFileManager* fileManager = [NSFileManager defaultManager]; 
        
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
        BOOL exists = [fileManager fileExistsAtPath:writableDBPath];
        if (exists && !forceOverwrite)
            continue;
        
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        NSError *error;
        if(exists)
            [fileManager removeItemAtPath:writableDBPath error:&error];
        [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    return success;
}

// Every so often, check my server for updated data files.
-(void) checkForNewFiles
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDate *lastTime = [NSDate dateWithTimeIntervalSince1970:[defaults doubleForKey:@"fileUpdateTime"]];
	NSDate *now = [NSDate date];
	
	NSTimeInterval interval = [now timeIntervalSinceDate:lastTime];
	
	if(interval < 3600 * 2) // 2 hours
    {
        return;
    }
    
    
    // Call function in CheckForUpdatesController
    CheckForUpdatesController *anotherViewController = [[CheckForUpdatesController alloc] init];
    [anotherViewController checkForUpdatesAsync];
    
}


- (void)dealloc {
    [super dealloc];
}


@end

