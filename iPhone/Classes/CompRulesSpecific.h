//
//  CompRulesSpecific.h
//  MTGJudge
//
//  Created by Alexei Gousev on 4/3/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompRulesSpecific : UIViewController {

	IBOutlet UIWebView *textView;
	NSString *target;
	NSArray *CompRulesArray;
	
	bool hideNavigation;
}

-(void) setTarget:(NSString*) t;
-(void) hideNavigationUponLeaving;

@property(nonatomic,retain) IBOutlet UIWebView *textView;

@end
