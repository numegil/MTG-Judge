//
//  IPGDetail.m
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import "IPGDetail.h"


@implementation IPGDetail

@synthesize textView;


-(void) setRoot:(int)r sub:(int)subR opt:(int)o stop:(NSString *)s
{
	root = r;
	subRoot = subR;
	option = o;
	stopText = s;
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
	
	textView.text = @"Hello!";
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if(root == 0 || root == 1 || subRoot == 0) // FCE or General Philosophy or Introduction section
	{
		if(root == 0) // FCE
		{
			NSString *FCEPath = [documentsDirectory stringByAppendingString:@"/FCE.txt"];
			NSString *tempFCE = [NSString stringWithContentsOfFile:FCEPath];
			
			IPGArray = [tempFCE componentsSeparatedByString:@"\n"];
		}
		else // General Philosophy or Introduction
		{
			NSString *IPGPath = [documentsDirectory stringByAppendingString:@"/IPG.txt"];
			NSString *tempIPG = [NSString stringWithContentsOfFile:IPGPath];
			
			IPGArray = [tempIPG componentsSeparatedByString:@"\n"];
		}
		
		BOOL foundSection = false;
		
		NSString *line;
		NSString *output = @"";
		
		NSString *targetSection = [NSString stringWithFormat:@"Start - %d", root];
		if(root == 0 || root == 1) targetSection = [NSString stringWithFormat:@"Stop - %d", subRoot];
		
		for(int i = 0; i < [IPGArray count]; i++)
		{
			line = [IPGArray objectAtIndex:i];
			
			if(foundSection)
			{
				if( [line rangeOfString:stopText options:NSAnchoredSearch].location != NSNotFound )
					break;
				output = [output stringByAppendingString:[line stringByAppendingString:@"\n"]];
			}
			else{
				if( [line rangeOfString:targetSection options:NSAnchoredSearch].location != NSNotFound )
					foundSection = true;
			}
		}
		
		textView.text = output;				
	}
	else // not FCE or Introductions
	{
		NSString *IPGPath = [documentsDirectory stringByAppendingString:@"/IPG.txt"];
		NSString *tempIPG = [NSString stringWithContentsOfFile:IPGPath];
		
		IPGArray = [tempIPG componentsSeparatedByString:@"\n"];
		
		BOOL foundSection = false;
		BOOL foundOption = false;
		
		NSString *line;
		NSString *output = @"";
		
		NSString *targetSection = [NSString stringWithFormat:@"%d.%d.", root, subRoot];
		NSString *targetOption = @"";
		switch(option)
		{
			case 1: targetOption = @"Definition"; break;
			case 2: targetOption = @"Examples"; break;
			case 3: targetOption = @"Philosophy"; break;
			case 4: targetOption = @"Penalty"; break;
		}
		if(root == 6 && option == 3) targetOption = @"Penalty";
		
		for(int i = 0; i < [IPGArray count]; i++)
		{
			line = [IPGArray objectAtIndex:i];
			
			if(foundSection && foundOption)
			{
				if( [line isEqualToString:@"Definition"] || [line isEqualToString:@"Examples"] || [line isEqualToString:@"Philosophy"] || [line isEqualToString:@"Penalty"])
					break;
				if( [line rangeOfString:stopText options:NSAnchoredSearch].location != NSNotFound )
					break;
				output = [output stringByAppendingString:[line stringByAppendingString:@"\n"]];
			}
			else if(foundSection)
			{
				if([line isEqualToString:targetOption])
					foundOption = true;
			}
			else{
				if( [line rangeOfString:targetSection options:NSAnchoredSearch].location != NSNotFound )
					foundSection = true;
			}
		}
		
		textView.text = output;
		
	} // else not FCE
	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
