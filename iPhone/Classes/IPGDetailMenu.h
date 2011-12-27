//
//  IPGDetailMenu.h
//  MTGJudge
//
//  Created by Alexei Gousev on 3/19/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPGDetailMenu : UITableViewController {

	int root;
	int subRoot;
}

-(void) setRoot: (int)r setSubRoot: (int)subR;
-(NSString *) getText:(int)index sub:(int)indexPath;

@end
