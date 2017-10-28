
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import <UIKit/UIKit.h>
// We need to import GameKit framework for connecting devices
#import <GameKit/GameKit.h>

@interface ListOfTasksViewController : UIViewController
{
    // Interface
    IBOutlet UILabel    *labelTaskName;
    IBOutlet UILabel    *labelTaskDescription;

}
-(void) ReceiveTask:(NSDictionary*)aTask;

@end
