//
//  QuickReferenceDetailController.h
//  MTGJudge
//
//  Created by Alexei Gousev on 1/22/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickReferenceDetailController : UIViewController {
	
	int index;
	IBOutlet UIImageView *imageView;
}

@property(nonatomic) int index;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;

- (BOOL)hidesBottomBarWhenPushed;

@end
