
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfTasksViewController : UIViewController
{
    int currentTouchingItemIndex; // Mark the index of touched item before we move it.
    NSString* currentTouchView;   // Mark the name of current touched view.
    
    // Interface
    IBOutlet UIImageView* todoTaskHolderView; // Using to determine where should we put TODO tasks in.
    IBOutlet UIImageView* doneTaskHolderView; // Using to determine where should we put DONE tasks in.
    IBOutlet UIView*      dragAndDropTablesContainer; // Using to hold TODO and DONE tasks.
    
    // Tasks container
    NSMutableArray* listOfTODOTasks; // Contain all data of TODO tasks
    NSMutableArray* listOfDONETasks; // Contain all data of DONE tasks
}

-(void) receiveTask:(NSDictionary*)aTask;
@end
