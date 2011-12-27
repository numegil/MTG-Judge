//
//  MTGJudgeAppDelegate.h
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright UC Davis 2010. All rights reserved.
//

@interface MTGJudgeAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	UITabBarController *tabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

@end

