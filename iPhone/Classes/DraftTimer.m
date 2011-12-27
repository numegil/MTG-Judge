//
//  DraftTimer.m
//  MTGJudge
//
//  Created by Alexei Gousev on 9/27/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import "DraftTimer.h"

@implementation DraftTimer

@synthesize topLabel, timeLabel, pickLabel, nextButton, previousButton, startButton, timer, endTime;

-(void) setTopLabelText:(NSString *)str
{
    CGSize maximumSize = CGSizeMake(300, 9999);
    
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:23];
    
    if([str length] > 80)
        dateFont = [UIFont fontWithName:@"Helvetica" size:19];
                 
    CGSize dateStringSize = [str sizeWithFont:dateFont 
                                   constrainedToSize:maximumSize 
                                       lineBreakMode:self.topLabel.lineBreakMode];
    
    CGRect dateFrame = CGRectMake(0, 20, 320, dateStringSize.height);
    
    self.topLabel.frame = dateFrame;
    self.topLabel.text = str;
    self.topLabel.font = dateFont;
}

-(void) startPick
{
    int pick = currentPick;
    int time = [self secondsForPick:pick];
    
    // Review period?
    if(currentPack != (int) currentPack)
    {
        if(currentPack == 1.5)
            time = 30;
        else if(currentPack == 2.5)
            time = 45;
    }
    
    currentState = STATE_NOT_STARTED;
    
    // Update time in UI
    [self updateTime:time];
    
    // Make top label visible
    [self.topLabel setAlpha:1];
    
    // Review period?
    if(currentPack != (int)currentPack)
    {
        [self setTopLabelText:[NSString stringWithFormat:@"You now have %d seconds to review your picks.", time]];
    }
    
    else if(currentPick == 1)
    {
        NSString *packNumberString = @"first";
        if(currentPack == 2)
            packNumberString = @"second";
        if(currentPack == 3)
            packNumberString = @"third";
        
        //self.topLabel.font = [UIFont fontWithName:@"Helvetica" size:23];
        [self setTopLabelText:[NSString stringWithFormat:@"Open your %@ pack and count out the cards face down in front of you. You should have %d cards.", packNumberString, 15-currentPick]];
    }
    else
    {
        NSString *passDirection = @"left";
        if(currentPack == 2)
            passDirection = @"right";
        [self setTopLabelText:[NSString stringWithFormat:@"Lay out your pack to your %@.\nYou should have %d cards.", passDirection, 15-currentPick]];
        
        if(currentPick == 14)
        {
            [self setTopLabelText:@"Pass your last card."];
            currentState = STATE_DONE;
        }
    }
    
    // Make sure we aren't running yet
    [timer invalidate];
    
    // Update pick label
    [self updateUI];
    
    // Update button text
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}

-(IBAction)nextClicked:(id)sender
{
    currentPick++;
    
    // If we just finished a pack
    if(currentPick > 14)
    {
        // If we're done with the draft
        if(currentPack == 3)
        {
            // Undo change from earlier
            currentPick--;
            return;
        }
        
        currentPick = 0;
        currentPack += .5;
    }
    
    // Else if we just finished a review period
    else if(currentPack != (int)currentPack)
    {
        currentPack += .5;
    }
    
    [self startPick];
}

-(IBAction)previousClicked:(id)sender
{
    if(currentState == STATE_NOT_STARTED)
        currentPick--;
    
    // Last pick of the pack
    if(currentState == STATE_DONE && currentPick == 14)
        currentPick--;
    
    if(currentPack != (int) currentPack)
    {
        currentPack -= .5;
        currentPick = 14;
    }
    
    else if(currentPick <= 0)
    {
        // Beginning of draft
        if(currentPack == 1)
        {
            currentPick = 1;
            currentPack = 1;
            return;
        }
        
        currentPack -= .5;
    }
    
    [self startPick];    
}

-(IBAction)startClicked:(id)sender
{
    if(currentState == STATE_NOT_STARTED)
    {
        currentState = STATE_RUNNING;
        
        // Update top label
        if(currentPack == (int)currentPack) // not a review period
        {
            [self setTopLabelText:[NSString stringWithFormat:@"Pick up your pack.\nYou have %d seconds.", [self secondsForPick:currentPick]]];
        }
        else
        {
            [self setTopLabelText:[NSString stringWithString:@"Please begin."]];
        }
        
        int time = [self secondsForPick:currentPick];
        if(currentPack != (int) currentPack)
        {
            if(currentPack == 1.5)
                time = 30;
            if(currentPack == 2.5)
                time = 45;
        }
        // Define timer end time
        self.endTime = [NSDate dateWithTimeIntervalSinceNow:time];
        
        // Start timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateTimeSelector:) userInfo:nil repeats:YES];
        
        // Fade out top label
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:4.0];
        [self.topLabel setAlpha:0];
        [UIView commitAnimations];
        
        // Update button text
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        // Only trigger five second warning if there's more than 5 seconds for the pick.
        if([self secondsForPick:currentPick] > 5 || currentPack != (int) currentPack)
            fiveSecondsTriggered = false;
        else
            fiveSecondsTriggered = true;
    }
    else if(currentState == STATE_RUNNING)
    {
        currentState = STATE_PAUSED;
        
        // Update button text
        [self.startButton setTitle:@"Resume" forState:UIControlStateNormal];
        
        // Make top label visible
        [self.topLabel setAlpha:1];
        
        // Set top label text
        [self setTopLabelText:@"Paused..."];
        
        // Stop timer
        [timer invalidate];
    }
    else if(currentState == STATE_PAUSED)
    {
        currentState = STATE_RUNNING;
        
        // Update button text
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        // Make top label visible
        [self.topLabel setAlpha:1];
        
        // Set top label text
        [self setTopLabelText:@""];
        
        // Redefine endTime based on label contents
        float timeLeft = [[timeLabel text] doubleValue];
        self.endTime = [NSDate dateWithTimeIntervalSinceNow:timeLeft];
        
        // Restart timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateTimeSelector:) userInfo:nil repeats:YES];
    }
    
}

// Assuming 14 card boosters
-(int) secondsForPick:(int)pick
{
    switch(pick)
    {
        case 1:
            return 40;
        case 2:
            return 35;
        case 3:
            return 30;
        case 4:
        case 5:
            return 25;
        case 6:
        case 7:
            return 20;
        case 8:
            return 15;
        case 9:
        case 10:
            return 10;
        case 11:
        case 12:
        case 13:
            return 5;
        case 14:
            return 0;
        default:
            return -1; // error   
    }
}

-(void) updateUI
{
    NSString *currentPickString = [NSString stringWithFormat:@"Pack %d, Pick %d", (int)currentPack, currentPick];
    
    // If it's a review period
    if(currentPack != (int) currentPack)
    {
        NSString *firstSecond = @"First";
        if(currentPack == 2.5)
            firstSecond = @"Second";
        currentPickString = [NSString stringWithFormat:@"%@ review period.", firstSecond];
    }
    
    self.pickLabel.text = currentPickString;
}

-(void) updateTime:(float)time
{
	int intervalTimesHundred = (int)(time * 100);
    
    NSString *timeDisplay = [NSString stringWithFormat:@"%d.%02d", intervalTimesHundred/100, intervalTimesHundred%100];
    self.timeLabel.text = timeDisplay;
}

// Called only by the NSTimer
-(void) updateTimeSelector:(id)selector
{
	NSDate *now = [NSDate date];
	int intervalTimesHundred = (int)([endTime timeIntervalSinceDate:now] * 100);
    
    // If we're under 5 seconds for the first time...
    if(!fiveSecondsTriggered && intervalTimesHundred < 500)
    {
        // Make sure we don't re-trigger
        fiveSecondsTriggered = true;
        
        // Make top label visible
        [self.topLabel setAlpha:1];
        
        // Set top label text
        [self setTopLabelText:@"Five seconds!"];
        
        // Fade top label out again
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:3.0];
        [self.topLabel setAlpha:0];
        [UIView commitAnimations];        
    }
    
    // If countdown is complete...
    else if(intervalTimesHundred <= 0)
    {
        // Make sure we don't display something negative.
        intervalTimesHundred = 0;
        
        // Disable timer
        [timer invalidate];
        
        // Make top label visible
        [self.topLabel setAlpha:1];
        
        // Set top label text
        if(currentPack == (int) currentPack) // not a review period
        {
            [self setTopLabelText:@"Draft!"];
        }
        else
        {
            [self setTopLabelText:@"Return your picks to a single face down pile."];
        }
        
        currentState = STATE_DONE;
    }
    
    NSString *timeDisplay = [NSString stringWithFormat:@"%d.%02d", intervalTimesHundred/100, intervalTimesHundred%100];
    self.timeLabel.text = timeDisplay;
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
    // Do any additional setup after loading the view from its nib.
    
    currentState = STATE_NOT_STARTED;
    
    currentPack = 1;
    currentPick = 1;
    
    [self updateUI];
    
    [self startPick];
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
