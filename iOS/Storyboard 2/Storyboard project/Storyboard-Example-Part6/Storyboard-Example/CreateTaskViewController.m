
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

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary *aTask = [[NSMutableDictionary alloc] init];
    [aTask setObject:taskDescriptionText.text forKey:taskNameText.text];
    [(ListOfTasksViewController*)self.presentingViewController ReceiveTask:aTask];
    [aTask release];
    [super viewWillDisappear:animated];
}

-(IBAction)createTaskButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
