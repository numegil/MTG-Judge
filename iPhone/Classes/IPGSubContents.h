//
//  CompRulesSubContents.h
//  MTGJudge
//
//  Created by Alexei Gousev on 1/28/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPGSubContents: UITableViewController {
	
	int index;
	
}

-(void) setIndex:(int)indx;
-(NSString *) getText: (int) indx;

@end
