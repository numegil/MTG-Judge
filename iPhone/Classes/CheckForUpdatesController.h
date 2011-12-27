//
//  CheckForUpdatesController.h
//  MTGJudge
//
//  Created by Alexei Gousev on 9/10/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "MTGJudgeAppDelegate.h"

@interface CheckForUpdatesController : UIViewController

{
    IBOutlet UIButton* tryAgainButton;
    IBOutlet UILabel* statusLabel;
    //IBOutlet UILabel* lastUpdatedLabel;
    
    // Stuff for auto-updating data
	NSString *baseURL;
	NSMutableArray *toDownload;
	NSMutableData *receivedData;
	UIAlertView *alert;
	NSMutableArray *newVcLocal;
	NSString *vcFile;
	LoadingView *loadingView;
	
	int currentlyDownloading;
}

@property(nonatomic, retain) IBOutlet UIButton* tryAgainButton;
@property(nonatomic, retain) IBOutlet UILabel* statusLabel;
//@property(nonatomic, retain) IBOutlet UILabel* lastUpdatedLabel;

-(void) startDownloading:(NSString*) fileName;

@property(nonatomic, retain) NSMutableArray *toDownload;
@property(nonatomic, retain) NSString *baseURL;
@property(nonatomic, retain) UIAlertView *alert;
@property(nonatomic, retain) NSMutableArray *newVcLocal;
@property(nonatomic, retain) NSString *vcFile;
@property(nonatomic, retain) LoadingView *loadingView;

-(void) checkForUpdatesAsync;
-(void) checkForUpdates;
//-(NSString*) getLastUpdatedString;

-(IBAction) tryAgainClicked;


@end
