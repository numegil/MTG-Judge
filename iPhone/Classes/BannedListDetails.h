//
//  BannedListDetails.h
//  MTGJudge
//
//  Created by Alexei Gousev on 9/9/11.
//  Copyright 2011 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannedListDetails : UIViewController
{
    NSString* format;
    
    IBOutlet UITextView *textView;
}

-(void) setFormat:(NSString*)f;

@property(nonatomic, retain) IBOutlet UITextView *textView;

@end
