//
//  CompRulesSubContents.h
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompRulesSubContents : UITableViewController {

	int index;
	NSArray *CompRulesArray;
	int numElements;
}

-(void) setIndex:(int)indx;
-(NSString *) getSubtext: (int) indx;

-(void) openRule:(int)indx with:(int)indx2;

@property(nonatomic,retain) NSArray *CompRulesArray;

@end
