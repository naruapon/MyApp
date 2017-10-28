
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import "ListOfTasksViewController.h"

@interface ListOfTasksViewController ()

@end

@implementation ListOfTasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark Task actions

// This function is called when CreateTasksViewController's dissapeared
-(void) ReceiveTask:(NSDictionary*)aTask{
    // Get the task name as a key of NSDictionary.
    NSArray *keys = [aTask allKeys];
    NSString* taskName = [keys objectAtIndex:0];
    // Set text for the label
    [labelTaskName setText:taskName];
    
    // Log description text to console.
    NSLog(@"%@",[aTask objectForKey:taskName]);
}
@end
