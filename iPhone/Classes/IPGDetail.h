//
//  IPGDetail.h
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPGDetail : UIViewController {

	IBOutlet UITextView *textView;
	int root, subRoot, option;
	NSString *stopText;
	
	NSArray *IPGArray;
}

-(void) setRoot:(int)r sub:(int)subR opt:(int)o stop:(NSString*)s;

@property(nonatomic,retain) IBOutlet UITextView *textView;

@end
