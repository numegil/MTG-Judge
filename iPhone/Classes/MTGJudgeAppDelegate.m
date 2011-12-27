//
//  MTGJudgeAppDelegate.m
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import "MTGJudgeAppDelegate.h"
#import "QuickReferenceController.h"
#import "CompRulesSpecific.h"


@implementation MTGJudgeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[tabController view]];
    [window makeKeyAndVisible];
	
	//NSURL *testU = [NSURL URLWithString:@"mtgjudge://601.2e"];
	//[self application:self handleOpenURL:testU];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
    //showUsageAlert = NO;
	
    // You should be extremely careful when handling URL requests.
    // You must take steps to validate the URL before handling it.
    
    if (!url) {
        // The URL is nil. There's nothing more to do.
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    
    NSString *message = [[URLString componentsSeparatedByString:@"//"] objectAtIndex:1];
	
	/*
    UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"handleOpenURL:" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [openURLAlert show];
    [openURLAlert release];
	 */
    
    if (!URLString) {
        // The URL's absoluteString is nil. There's nothing more to do.
        return NO;
    }
    
    // Your application is defining the new URL type, so you should know the maximum character
    // count of the URL. Anything longer than what you expect is likely to be dangerous.
    NSInteger maximumExpectedLength = 50;
    
    if ([URLString length] > maximumExpectedLength) {
        // The URL is longer than we expect. Stop servicing it.
        return NO;
    }
	
	MTGJudgeAppDelegate *del = (MTGJudgeAppDelegate *)[UIApplication sharedApplication].delegate;
	NSArray *v = [[del tabController] viewControllers];	
	
	UINavigationController *c = [v objectAtIndex:3];
	
	CompRulesSpecific *anotherViewController = [[CompRulesSpecific alloc] init];
	
	NSString *aTitle = [NSString stringWithFormat:@"Rule %@", message];
	NSString *bTitle = [NSString stringWithFormat:@"%@", message];
	[bTitle retain];
	
	anotherViewController.title = aTitle;
	[anotherViewController setTarget:bTitle];
	
	[c pushViewController:anotherViewController animated:YES];
	
	[anotherViewController release];
	
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

