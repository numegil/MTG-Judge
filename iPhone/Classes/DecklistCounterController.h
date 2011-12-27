//
//  DecklistCounter.h
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DecklistCounterController : UIViewController <UIAccelerometerDelegate,UIAlertViewDelegate> {
	
	int total;
	int change;
	int secondController;
	
	IBOutlet UILabel *outputLabel;
	IBOutlet UIButton *button1;
	IBOutlet UIButton *button2;
	IBOutlet UIButton *button3;
	IBOutlet UIButton *button4;
	IBOutlet UIButton *buttonReset;
	IBOutlet UIButton *buttonUndo;
	
	NSTimeInterval lastTwitch;
	bool fullscreen;
	
	bool useFullscreen;

}

@property(nonatomic,retain) IBOutlet UILabel *outputLabel;
@property(nonatomic,retain) IBOutlet UIButton *button1;
@property(nonatomic,retain) IBOutlet UIButton *button2;
@property(nonatomic,retain) IBOutlet UIButton *button3;
@property(nonatomic,retain) IBOutlet UIButton *button4;
@property(nonatomic,retain) IBOutlet UIButton *buttonReset;
@property(nonatomic,retain) IBOutlet UIButton *buttonUndo;

-(IBAction) button1Pressed;
-(IBAction) button2Pressed;
-(IBAction) button3Pressed;
-(IBAction) button4Pressed;
-(IBAction) resetPressed;
-(IBAction) undoPressed;
-(void) toggleView;
-(void) configView;

@end
