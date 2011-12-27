//
//  CheckForUpdatesController.m
//  MTGJudge
//
//  Created by Alexei Gousev on 9/10/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import "CheckForUpdatesController.h"

@implementation CheckForUpdatesController

@synthesize tryAgainButton, statusLabel; //, lastUpdatedLabel;

@synthesize toDownload;
@synthesize baseURL;
@synthesize newVcLocal;
@synthesize vcFile;
@synthesize loadingView;
@synthesize alert;

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
    
    // Update "last updated" label
    //lastUpdatedLabel.text = [self getLastUpdatedString];
    
    [self checkForUpdatesAsync];
    
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

-(IBAction)tryAgainClicked
{
    [self checkForUpdatesAsync];
}

-(void) checkForUpdatesAsync
{
    tryAgainButton.hidden = TRUE;
    [self.statusLabel setText:@"Checking for updates..."];
    
    [self performSelectorInBackground:@selector(checkForUpdates) withObject:nil];
}

-(void) checkForUpdates
{
    // For async method
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDate *now = [NSDate date];
    
	[defaults setDouble:[now timeIntervalSince1970] forKey:@"fileUpdateTime"];
	
	NSStringEncoding encoding = 1;
	
    self.baseURL = [NSString stringWithString:@"http://files.mtgarchive.com/mtgjudge/"];
    
	// Prepare local version control array
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
	self.vcFile = [documentsDirectory stringByAppendingString:@"/version_control.array"];
	NSArray *vcLocal = [NSArray arrayWithContentsOfFile:vcFile];
	self.newVcLocal = [NSMutableArray array];
	
	
	// Iterate through each file and download it if necessary
	NSString *versionControlURL = [self.baseURL stringByAppendingString:@"version_control.txt"];
	NSString *versionControlContents = [NSString stringWithContentsOfURL:[NSURL URLWithString:versionControlURL] encoding:encoding error:NULL];
	NSArray *versionControlLines = [versionControlContents componentsSeparatedByString:@"\n"];
	
    // no internet or file not found
	if([versionControlLines count] == 0 || !([[versionControlLines objectAtIndex:0] isEqualToString:@"verified"]))
    {
        [self.statusLabel setText:@"No internet connection!"];
        
        tryAgainButton.hidden = FALSE;
        [pool release];
        return;
    }
	
	self.toDownload = [NSMutableArray array];
	
	for(int i = 2; i < [versionControlLines count]; i += 3)
	{
		NSString *fileName = [versionControlLines objectAtIndex:i];
		NSString *stringRevNum = [versionControlLines objectAtIndex:i+1];
		
		NSString *localRevNum = [[vcLocal objectAtIndex:(i-2)/3] objectAtIndex:1];
		if([stringRevNum intValue] > [localRevNum intValue])
		{
			NSLog(@"Need to update %@", fileName);
			//self.title = fileName;
			
			[toDownload addObject:[NSString stringWithString:fileName]];			
		}
		
		[newVcLocal addObject:[NSArray arrayWithObjects:fileName, stringRevNum, nil]];
	}
	
	if([toDownload count] != 0)
	{
		currentlyDownloading = 0;
		NSString *text = [NSString stringWithFormat:@"%d updated files found.  Update now?  (This may take a few minutes).",[toDownload count]];
		alert = [[[UIAlertView alloc] initWithTitle:@"Updated file(s) found!" message:text delegate:self cancelButtonTitle:@"Update" otherButtonTitles:@"Not now", nil] autorelease];
		[alert show];
        
        [self.statusLabel setText:@"Updates available!"];
	}
    else
    {
        [self.statusLabel setText:@"No updates available."];
        tryAgainButton.hidden = FALSE;
    }
    
	[pool release];	
}


-(void) startDownloading:(NSString*) fileName
{
	NSURL *remoteURL = [NSURL URLWithString:[self.baseURL stringByAppendingString:fileName]];
	// Create the request.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:remoteURL
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
	} else {
		NSLog(@"Error!  NSURLConnection failed...");
	}
    
    [self.statusLabel setText:@"Downloading files..."];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
    
    tryAgainButton.hidden = FALSE;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[toDownload objectAtIndex:currentlyDownloading]];
	
	[receivedData writeToFile:filePath atomically:YES];
    
	
	currentlyDownloading++;
	
	// release the connection, and the data object
    [connection release];
    [receivedData release];
	
	if(currentlyDownloading < [toDownload count])
	{
		// UPDATE LOADING VIEW TEXT HERE
		[loadingView setText:[NSString stringWithFormat:@"Downloading %d out of %d", currentlyDownloading+1, [toDownload count]]];
		[self startDownloading:[toDownload objectAtIndex:currentlyDownloading]];
	}
	
	else { // done downloading
		
		[newVcLocal writeToFile:vcFile atomically:NO];
        
        [loadingView removeView];
		
		alert = [[[UIAlertView alloc] initWithTitle:@"Done updating!" message:@"You may have to restart the app for the changes to take effect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
        
        [self.statusLabel setText:@"Successfully updated!"];
        
        tryAgainButton.hidden = FALSE;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{	
	if(buttonIndex == 0 && ![alertView.title isEqualToString:@"Done updating!"])
	{
		MTGJudgeAppDelegate *del = (MTGJudgeAppDelegate *)[UIApplication sharedApplication].delegate;
		NSArray *v = [[del tabController] viewControllers];
		
		for(int i = 1; i < [v count]; i++)
		{
			[[v objectAtIndex:i] didReceiveMemoryWarning]; // reset other views
		}
		
		[self startDownloading:[toDownload objectAtIndex:0]];
		
		// CREATE LOADING VIEW HERE
		
		loadingView = [LoadingView loadingViewInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
		
		[loadingView setText:[NSString stringWithFormat:@"Downloading %d out of %d", currentlyDownloading+1, [toDownload count]]];
		
	}
    else
    {
        tryAgainButton.hidden = FALSE;
    }
}

@end
