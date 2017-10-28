//
//  Created by Vit on 10/17/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import "Storyboard_ExampleViewController.h"
#import "ListOfTasksViewController.h"
@interface Storyboard_ExampleViewController ()

@end

@implementation Storyboard_ExampleViewController

#pragma mark View defailt methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Storyboard delegate stuff
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"GoToTaskListSegue"])
	{
        // Get reference to the destination view controller
        ListOfTasksViewController *taskListView = (ListOfTasksViewController*)[segue destinationViewController];
            // Send your data or call any function here.
            [taskListView initializeConnector];
	}
}
@end
