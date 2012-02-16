//
//  CompRulesDetails.m
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "CompRulesDetails.h"


@implementation CompRulesDetails

@synthesize textView;

-(void) setRoot:(int)r sub:(int)subR stop:(NSString *)st
{
	root = r;
	subRoot = subR;
	stopDisplaying = st;
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

-(void) hideNavigationUponLeaving
{
	hideNavigation = true;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	hideNavigation = false;
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
	NSString *RulesPath = [documentsDirectory stringByAppendingString:@"/CompRules.txt"];
	if(root == 10) RulesPath = [documentsDirectory stringByAppendingString:@"/CompRulesGlossary.txt"];
	
	NSStringEncoding encoding = 1;
	NSString *tempRules = [NSString stringWithContentsOfFile:RulesPath usedEncoding:&encoding error:NULL];
	
	CompRulesArray = [tempRules componentsSeparatedByString:@"\n"];
	
	BOOL found = false;
	
	NSString *output = @"";
	
	if(root != 10)
	{
		for(int i = 0; i < [CompRulesArray count]; i++)
		{			
			if(found)
			{
				
				NSRange textRange;
				textRange =[[CompRulesArray objectAtIndex:i] rangeOfString:stopDisplaying];
				
				if(textRange.location != NSNotFound)
				{
					break;
				}
				
				output = [output stringByAppendingString:[[CompRulesArray objectAtIndex:i] stringByAppendingString:@"<br>"]];
			}
						
			else 
			{
				NSRange textRange;
				textRange =[[CompRulesArray objectAtIndex:i] rangeOfString:self.title];
				if(textRange.location != NSNotFound) found = true;
			}
			

		}
	}
	else
	{
		NSString *tempString;
		int arrayIndex = 0;
		
		// find Nth entry
		for(int i = 0; i < subRoot; i++)
		{
			tempString = [CompRulesArray objectAtIndex:arrayIndex];
			while([tempString length] > 1) // go to next newline
			{
				arrayIndex++;
				tempString = [CompRulesArray objectAtIndex:arrayIndex];
			}
			arrayIndex++;
		}
		
		// Process entry
		arrayIndex++;
		tempString = [CompRulesArray objectAtIndex:arrayIndex];
		while([tempString length] > 1)// && arrayIndex < [CompRulesArray count]) // continue until next newline
		{
			tempString = [CompRulesArray objectAtIndex:arrayIndex];
			arrayIndex++;
			output = [[output stringByAppendingString:tempString] stringByAppendingString:@"<br>"];
			if(arrayIndex >= [CompRulesArray count]) break;
		}		
	}

	[textView loadHTMLString:output baseURL:[NSURL URLWithString:@"http://google.com"]];
		
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		if(hideNavigation)
		{
			[self.navigationController setNavigationBarHidden:YES animated:NO];
			hideNavigation = false;
		}
    }
    [super viewWillDisappear:animated];
}

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


- (void)dealloc {
    [super dealloc];
}


@end
