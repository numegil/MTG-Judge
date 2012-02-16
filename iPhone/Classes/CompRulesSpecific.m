//
//  CompRulesSpecific.m
//  MTGJudge
//
//  Created by Alexei Gousev on 4/3/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import "CompRulesSpecific.h"


@implementation CompRulesSpecific

@synthesize textView;


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
	// assuming that we never need to link to a glossary entry
	
	NSStringEncoding encoding = 1;
	NSString *tempRules = [NSString stringWithContentsOfFile:RulesPath usedEncoding:&encoding error:NULL];
	
	CompRulesArray = [tempRules componentsSeparatedByString:@"\n"];
	BOOL found = false;
	
	NSString *output = @"";

	for(int i = 0; i < [CompRulesArray count]; i++)
	{	
		NSRange textRange;
		textRange = [[CompRulesArray objectAtIndex:i] rangeOfString:target];
		
		if(!found && textRange.location <= 1)
		{
			found = true;
            NSLog(@"Found - %@", [CompRulesArray objectAtIndex:i]);
		}
		
		else if(found && textRange.location == NSNotFound && [[CompRulesArray objectAtIndex:i] length] > 1)
        {
            NSLog(@"Not found - %@", [CompRulesArray objectAtIndex:i]);
			break;
		}
        
		if(found) output = [output stringByAppendingString:[[CompRulesArray objectAtIndex:i] stringByAppendingString:@"<br>"]];

	}
	
	[textView loadHTMLString:output baseURL:[NSURL URLWithString:@"http://google.com"]];
	
}

-(void) setTarget:(NSString *)t
{
	target = t;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
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
