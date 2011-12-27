//
//  DecklistCounter.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "DecklistCounterController.h"


@implementation DecklistCounterController

@synthesize outputLabel;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize buttonReset;
@synthesize buttonUndo;

-(void) configView
{
	fullscreen = TRUE;
	secondController = 1337;
	
	//CGRect rect0 = {{0,0},{320,480}};
	CGRect rect1 = {{0,0},{160,240}};
	CGRect rect2 = {{160,0},{160,240}};
	CGRect rect3 = {{0,240},{160,240}};
	CGRect rect4 = {{160,240},{160,240}};
	
	button1.frame = rect1;
	button2.frame = rect2;
	button3.frame = rect3;
	button4.frame = rect4;
	buttonReset.hidden = TRUE;
	buttonUndo.hidden = TRUE;
	
	//self.tabBarController.tabBar.hidden = YES;
	//[self.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
	[self.view setFrame:CGRectMake(0,0,320,480)];
	[self.view setBounds:CGRectMake(0,0,320,480)];
}

-(void) toggleView
{
	fullscreen = !fullscreen;
	
	if(fullscreen)
	{
		// Create the root view controller for the navigation controller
		// The new view controller configures a Cancel and Done button for the
		// navigation bar.
		DecklistCounterController *addController = [[DecklistCounterController alloc]
												  initWithNibName:@"DecklistCounterControllerFullscreen" bundle:nil];
		//addController.delegate = self;
		
		[addController configView];
		addController->lastTwitch = lastTwitch;
		
		// Create the navigation controller and present it modally.
		//UIViewController *navigationController = [[UIViewController alloc]
														//initWithRootViewController:addController];
		[self presentModalViewController:addController animated:NO];
		
		// The navigation controller is now owned by the current view controller
		// and the root view controller is owned by the navigation controller,
		// so both objects should be released to prevent over-retention.
		// π[navigationController release];
		[addController release];
	}
	else
	{
		[self dismissModalViewControllerAnimated:NO];
	}

}

-(void) updateLabel
{
	NSString *display = [NSString stringWithFormat:@"Total: %i ",total];
	if(change != 0) display = [display stringByAppendingFormat:@"(+%i)",change];
	
	outputLabel.text = display;	
}

-(IBAction) button1Pressed
{
	total += 1;
	change = 1;
	[self updateLabel];
}

-(IBAction) button2Pressed
{
	total += 2;
	change = 2;
	[self updateLabel];
}

-(IBAction) button3Pressed
{
	total += 3;
	change = 3;
	[self updateLabel];
}

-(IBAction) button4Pressed
{
	total += 4;
	change = 4;
	[self updateLabel];
}

-(IBAction) resetPressed
{
	change = 0;
	total = 0;
	[self updateLabel];
}

-(IBAction) undoPressed
{
	total -= change;
	change = 0;
	[self updateLabel];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//lastTwitch = 0.0;
	if(secondController != 1337) 
	{
		// open a alert with an OK and cancel button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fullscreen?" message:@"Do you wish to enable full screen mode using the accelerometer?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];	
		fullscreen = FALSE;
	}
	else 
	{
		fullscreen = TRUE;
		useFullscreen = TRUE;
	}
	

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		useFullscreen = FALSE;
	}
	else
	{
		useFullscreen = TRUE;
	}
}

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

- (void)viewDidDisappear:(BOOL)animated
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	if(!fullscreen && secondController != 1337) accel.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 1.0f/60.0f;
}




- (void)dealloc {
    [super dealloc];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)aceler
{
	//NSLog(@"%f",aceler.timestamp);
	
	if(!useFullscreen) return;
	
	if (aceler.timestamp > lastTwitch + .5 && (fabsf(aceler.x) > 1.75 || fabsf(aceler.y) > 1.75 || fabsf(aceler.z) > 1.75))
	{
		lastTwitch = aceler.timestamp;
		if(!fullscreen) [self toggleView];
		else {
			if(total == 0) [self toggleView];
			else [self resetPressed];
		}

	}
}

@end
