//
//  DraftTimer.h
//  MTGJudge
//
//  Created by Alexei Gousev on 9/27/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATE_NOT_STARTED 1000
#define STATE_PAUSED 1001
#define STATE_RUNNING 1002
#define STATE_DONE 1003

@interface DraftTimer : UIViewController
{   
    // This is a float so that I can represent the review periods as "packs" 1.5 and 2.5
    float currentPack;
    
    int currentPick;
    
    // Running, paused, or not started (see defines above)
    int currentState;
    
    bool fiveSecondsTriggered;
}

-(void) updateUI;

-(void) updateTime:(float)time;
-(void) updateTimeSelector:(id)selector;

-(void) startPick;
-(int) secondsForPick:(int)pick;

-(IBAction)previousClicked:(id)sender;
-(IBAction)nextClicked:(id)sender;
-(IBAction)startClicked:(id)sender;

-(void) setTopLabelText:(NSString*) str;

@property(nonatomic, retain) IBOutlet UILabel *topLabel;
@property(nonatomic, retain) IBOutlet UILabel *timeLabel;
@property(nonatomic, retain) IBOutlet UILabel *pickLabel;
@property(nonatomic, retain) IBOutlet UIButton *nextButton;
@property(nonatomic, retain) IBOutlet UIButton *previousButton;
@property(nonatomic, retain) IBOutlet UIButton *startButton;

@property(nonatomic, retain) NSTimer *timer;

// Keeps track of when the timer should run out (go to 0)
@property(nonatomic, retain) NSDate *endTime;

@end
