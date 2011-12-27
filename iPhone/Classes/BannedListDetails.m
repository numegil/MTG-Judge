//
//  BannedListDetails.m
//  MTGJudge
//
//  Created by Alexei Gousev on 9/9/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import "BannedListDetails.h"

@implementation BannedListDetails

@synthesize textView;

-(void) setFormat:(NSString*)f
{
    format = f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *BannedPath = [documentsDirectory stringByAppendingString:@"/Banned.txt"];
    NSString *tempBanned = [NSString stringWithContentsOfFile:BannedPath];
    
    NSArray *bannedArray = [tempBanned componentsSeparatedByString:@"\n"];
    
    NSString* output = @"";
    bool found = false;
    for(int i = 0; i < [bannedArray count]; i++)
    {
        
        if([[bannedArray objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"Format:%@\r", format]])
        {
            found = true;
            
            // Don't do anything else this iteration
            continue;
        }
        
        if(found && [[bannedArray objectAtIndex:i] rangeOfString:@"Format:"].location != NSNotFound)
            break;
        
        if(found)
        {
            output = [output stringByAppendingString:[bannedArray objectAtIndex:i]];
        }
        

    }
    
    self.textView.text = output;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
