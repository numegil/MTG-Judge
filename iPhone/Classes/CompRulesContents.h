//
//  CompRulesContents.h
//  MTGJudge
//
//  Created by Alexei Gousev on 3/20/10.
//  Copyright 2010 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompRulesContents : UIViewController <UISearchBarDelegate, UITableViewDelegate> {

	NSArray *CompRulesArray;
	NSArray *CompRulesFull;
	NSArray *CompRulesGlossary;
	
	IBOutlet UITableView *masterBaseTableView;
	
	// for searching
	NSMutableArray *searchResults;//will be storing data that will be displayed in table
	NSMutableArray *searchResultsIndexes;
	IBOutlet UISearchBar *sBar;
	NSString *lastSearchString;
	IBOutlet UISegmentedControl *typeOfSearchControl;
	IBOutlet UIToolbar *toolbar;
	bool searching;
	bool searchingForGlossary;
}

-(NSString *)getSectionName:(int)section;
-(IBAction) switchFlipped;
-(void) searchFor:(NSString*) searchString;

@property(nonatomic, retain) NSMutableArray *searchResults;
@property(nonatomic, retain) NSMutableArray *searchResultsIndexes;
@property(nonatomic, retain) NSString *lastSearchString;
@property(nonatomic, retain) IBOutlet UITableView *masterBaseTableView;
@property(nonatomic,retain) NSArray *CompRulesArray;
@property(nonatomic,retain) NSArray *CompRulesFull;
@property(nonatomic,retain) NSArray *CompRulesGlossary;
@property(nonatomic, retain) IBOutlet UISegmentedControl *typeOfSearchControl;
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;


@end
