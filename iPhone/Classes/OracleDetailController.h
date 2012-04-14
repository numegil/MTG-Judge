//
//  OracleDetailController.h
//  MTGJudge
//
//  Created by Alexei Gousev on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OracleDetailController : UITableViewController <UITableViewDelegate>
{
    NSString *oracleText;
    NSArray *triggers;
    NSArray *setInfo;
}

-(void) setOracle:(NSString *)o triggers:(NSArray *)t setInfo:(NSArray *)s;

@property(nonatomic, retain) NSString *oracleText;
@property(nonatomic, retain) NSArray *triggers;
@property(nonatomic, retain) NSArray *setInfo;

@end
