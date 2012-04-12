//
//  EditorViewController.h
//  Editor
//
//  Created by Alexei Gousev on 3/31/10.
//  Copyright UC Davis 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OracleLookupController : UIViewController <UISearchBarDelegate, UITableViewDelegate> {
	
	NSMutableArray *oracle; // names only
	NSMutableArray *oracleData; // array of alphabet arrays
    
    NSMutableArray *triggers; // for the 'lapsing', 'mandatory', etc. triggers
	
	IBOutlet UITableView *masterBaseTableView;
	
	// for searching TableView
	NSMutableArray *tableData;//will be storing data that will be displayed in table
	IBOutlet UISearchBar *sBar;
	BOOL searching;
	BOOL letUserSelectRow;
	NSString *lastSearchString;
	NSString *currentCard;
	
	IBOutlet UIImageView *gathererPicView;
	IBOutlet UITextView *oracleTextView;
	IBOutlet UIButton *returnButton;
	IBOutlet UISwitch *gathererPicSwitch;
	
	BOOL gathererPicMode;
}

@property (nonatomic, retain) NSMutableArray *oracle;
@property (nonatomic, retain) NSMutableArray *oracleData;
@property (nonatomic, retain) NSMutableArray *triggers;
@property (nonatomic, retain) IBOutlet UITableView *masterBaseTableView;
@property (nonatomic, retain) IBOutlet UITextView *oracleTextView;
@property (nonatomic, retain) IBOutlet UIImageView *gathererPicView;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) IBOutlet UIButton *returnButton;
@property (nonatomic, retain) NSString *lastSearchString;
@property (nonatomic, retain) IBOutlet UISwitch *gathererPicSwitch;

-(IBAction) returnButtonPressed;
-(IBAction) switchFlipped;

@end
