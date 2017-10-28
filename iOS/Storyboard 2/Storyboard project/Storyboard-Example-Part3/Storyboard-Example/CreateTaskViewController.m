
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "ListOfTasksViewController.h"
@interface CreateTaskViewController ()

@end

@implementation CreateTaskViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method is called before the view is no longer visible.
- (void)viewWillDisappear:(BOOL)animated
{
    [self sendATask];
    [super viewWillDisappear:animated];
}

-(void) sendATask {
    // Create a Dictionary to contain the Task.
    NSMutableDictionary *aTask = [[NSMutableDictionary alloc] init];
    [aTask setObject:taskDescriptionText.text forKey:taskNameText.text];
    //Call the source view method to pass the data.
    [(ListOfTasksViewController*)self.presentingViewController ReceiveTask:aTask];
    //Release memory
    [aTask release];
}

// This method is called when user click on 'Add this task' button.
-(IBAction)createTaskButtonClick:(id)sender {
    // Dismiss this view and go back to the source view.
    [self dismissModalViewControllerAnimated:YES];
}

@end
