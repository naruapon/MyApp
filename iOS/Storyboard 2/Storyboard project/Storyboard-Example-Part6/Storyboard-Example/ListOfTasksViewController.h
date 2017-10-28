
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import <UIKit/UIKit.h>
// We need to import GameKit framework for connecting devices
#import <GameKit/GameKit.h>

@interface ListOfTasksViewController : UIViewController <GKPeerPickerControllerDelegate,GKSessionDelegate>
{
    int currentTouchingItemIndex;
    NSString* currentTouchView;
    int receivedCount;
    
    // Interface
    IBOutlet UIImageView* todoTaskHolderView;
    IBOutlet UIImageView* doneTaskHolderView;
    IBOutlet UIView*      dragAndDropTablesContainer;
    
    // Tasks container
    NSMutableArray* listOfTODOTasks;
    NSMutableArray* listOfDONETasks;
    
    // Gamekit elements
    GKPeerPickerController *devicePicker;
    GKSession *currentSession;
    NSMutableArray *peers;
}
@property (retain) GKSession *currentSession;


-(void) setSession;
-(void) ReceiveTask:(NSDictionary*)aTask;
@end
