//
//  CompRulesDetails.h
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompRulesDetails : UIViewController {
	
	IBOutlet UIWebView *textView;
	int root, subRoot;
	
	NSArray *CompRulesArray;
	
	NSString *stopDisplaying;
	
	bool hideNavigation;
}

-(void) setRoot:(int)r sub:(int)subR stop:(NSString *)st;
-(void) hideNavigationUponLeaving;

@property(nonatomic,retain) IBOutlet UIWebView *textView;

@end
