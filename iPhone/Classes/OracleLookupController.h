//
//  EditorViewController.h
//  Editor
//
//  Created by Alexei Gousev on 3/31/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OracleDetailController;

@interface OracleLookupController : UIViewController <UISearchBarDelegate, UITableViewDelegate> {
	
	NSMutableArray *oracle; // names only
	
	IBOutlet UITableView *masterBaseTableView;
	
	// for searching TableView
	NSMutableArray *tableData;//will be storing data that will be displayed in table
	IBOutlet UISearchBar *sBar;
	BOOL searching;
	BOOL letUserSelectRow;
	NSString *lastSearchString;
	NSString *currentCard;
}

@property (nonatomic, retain) NSMutableArray *oracle;
@property (nonatomic, retain) NSMutableArray *oracleData;
@property (nonatomic, retain) NSMutableArray *triggers;
@property (nonatomic, retain) IBOutlet UITableView *masterBaseTableView;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSString *lastSearchString;

@end
