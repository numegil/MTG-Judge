//
//  QuickReferenceDetailController.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "QuickReferenceDetailController.h"


@implementation QuickReferenceDetailController

@synthesize index;
@synthesize imageView;


-(void) setIndex:(int)ind
{
	index = ind;
	
	NSString *partialPath = [NSString stringWithFormat:@"guide_%i",(index+1)];
	NSString * fullPath = [[NSBundle mainBundle] pathForResource:partialPath ofType:@"jpg"];
	
	imageView.image = [UIImage imageWithContentsOfFile:fullPath];

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
	
	// necessary in order to refresh view after view loaded
	[self setIndex:index];
}

- (BOOL)hidesBottomBarWhenPushed{
	return TRUE;
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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
