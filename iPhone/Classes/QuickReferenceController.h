//
//  RootViewController.h
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QuickReferenceDetailController;

@interface QuickReferenceController : UITableViewController {
	
}

-(void) checkForNewFiles;
-(bool) copyResourcesToDocuments;
@end
