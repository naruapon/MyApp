
//
//  Created by Vit on 10/22/12.
//  Copyright (c) 2012 BlueMango. All rights reserved.
//

#import "ListOfTasksViewController.h"
#define kViewTodo    @"TODO_VIEW"
#define kViewDone    @"DONE_VIEW"
#define kDataTodoKey @"TODO_DATA"
#define kDataDoneKey @"DONE_DATA"

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
	// Initialize arrays
    listOfTODOTasks = [[NSMutableArray alloc] init];
    listOfDONETasks = [[NSMutableArray alloc] init];
    
    currentTouchView = @"nil";
    currentTouchingItemIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [listOfDONETasks release];
    [listOfTODOTasks release];
    [super dealloc];
}


#pragma mark Task actions

// Add a new task into TODO list.
-(void) receiveTask:(NSDictionary*)aTask{
    [listOfTODOTasks addObject:aTask];
    // Redraw the view when a new task's added.
    [self drawTables];
}

-(void) moveTask:(NSDictionary*)aTask FromArray:(NSMutableArray*)sourceArray ToArray:(NSMutableArray*)targetArray{
    if ([sourceArray count] != 0) {
        [targetArray addObject:aTask];
        [sourceArray removeObject:aTask];
    }
}

// We use data from _listOfTODOTasks and convert it to items on view
-(void)drawTodoTable {
    if ([listOfTODOTasks count] != 0) { //Todo list is empty or not
        for (int i = 0; i < [listOfTODOTasks count]; i++) {
            [self addItem:i withData:(NSDictionary *)[listOfTODOTasks objectAtIndex:i] inView:todoTaskHolderView];
        }
    }
}

// We use data from _listOfDONETasks and convert it to items on view
-(void)drawDoneTable {
    if ([listOfDONETasks count] != 0) { //Done list is empty or not
        for (int i = 0; i < [listOfDONETasks count]; i++) {
            [self addItem:i withData:(NSDictionary *)[listOfDONETasks objectAtIndex:i] inView:doneTaskHolderView];
        }
    }
}

//Reload table
-(void) drawTables {
    for (UIView *view in dragAndDropTablesContainer.subviews) {
        if (view.tag != 9999) { // We set '9999' is the tag of two view Todo and Done to mark it.
            [view removeFromSuperview];
        }
    }
    [self drawTodoTable];
    [self drawDoneTable];
}

-(void)addItem:(int)itemIndex withData:(NSDictionary*)data inView:(UIImageView*)view{
    // Get task name
    NSArray *keys = [data allKeys];
    NSString* taskName = [keys objectAtIndex:0];
    // Create item as a UIButton.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + (25*(itemIndex+0)), view.frame.size.width, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"CellBackground.png"] forState:UIControlStateNormal];
    //Mark UIButton with item index.
    button.tag = itemIndex;
    // Set title for UIButton
    [button setTitle:taskName forState:UIControlStateNormal];
    // Add event to UIButton.
    [button addTarget:self action:@selector(itemTouched:withEvent:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(itemMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(itemTouchEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // add item to view
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       [dragAndDropTablesContainer addSubview:button];
    }completion:^(BOOL done){

    }];
}

// This method is called when we touch an item down.
// Used to mark what item has been touched.
- (void) itemTouched:(id) sender withEvent:(UIEvent *) event{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIButton* control = (UIButton*)sender;
    currentTouchView = [self dragInView:point];
    currentTouchingItemIndex = control.tag;
}

// This method is called when we move an item around.
// Used to get touch location and move the position of current touched item along.
- (void) itemMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIControl *control = sender;
    control.center = point;
}

// This method is called when we release the touch on an item.
// Used to get location of touch ended and put item in a correct position.
- (void) itemTouchEnded:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIButton* control = (UIButton*)sender;
    NSString* inView = [self dragInView:point];
    
    if (![currentTouchView isEqualToString:inView]) {
        UIImageView* target;
        if ([inView isEqualToString:kViewDone]) {
            [listOfDONETasks addObject:[listOfTODOTasks objectAtIndex:currentTouchingItemIndex]];
            [listOfTODOTasks removeObjectAtIndex:currentTouchingItemIndex];
            target = doneTaskHolderView;
        } else if ([inView isEqualToString:kViewTodo]){
            [listOfTODOTasks addObject:[listOfDONETasks objectAtIndex:currentTouchingItemIndex]];
            [listOfDONETasks removeObjectAtIndex:currentTouchingItemIndex];
            target = todoTaskHolderView;
        }
        //Using uiview animation
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [control setFrame:[self snapItemOnCorrectPositionIndex:currentTouchingItemIndex inView:[inView isEqualToString:kViewTodo] ? todoTaskHolderView : doneTaskHolderView ]];
            }completion:^(BOOL done){
                [self drawTables];
                currentTouchingItemIndex = -1;
                currentTouchView = @"nil";
            }];
    } else { // Move the item back if there's no change
         [control setFrame:[self snapItemOnCorrectPositionIndex:currentTouchingItemIndex inView:[inView isEqualToString:kViewTodo] ? todoTaskHolderView : doneTaskHolderView ]];
    }
}

// Depend on the index item, return the correct position of item when it's relreased.
-(CGRect) snapItemOnCorrectPositionIndex:(int)itemIndex inView:(UIImageView*)view{
    CGRect correctFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y + (25*(itemIndex+0)), view.frame.size.width, 25);
    return correctFrame;
}

// Depend on the view which we drag the item in, return name of that view.
- (NSString*) dragInView:(CGPoint)draggedPoint {
    if (draggedPoint.x > todoTaskHolderView.frame.origin.x && draggedPoint.x < todoTaskHolderView.frame.origin.x + todoTaskHolderView.frame.size.width) {
        if (draggedPoint.y > todoTaskHolderView.frame.origin.y && draggedPoint.y < todoTaskHolderView.frame.origin.y + todoTaskHolderView.frame.size.height) {
            return kViewTodo;
        }
    }
    else if (draggedPoint.x > doneTaskHolderView.frame.origin.x && draggedPoint.x < doneTaskHolderView.frame.origin.x + doneTaskHolderView.frame.size.width) {
        if (draggedPoint.y > doneTaskHolderView.frame.origin.y && draggedPoint.y < doneTaskHolderView.frame.origin.y + doneTaskHolderView.frame.size.height) {
            return kViewDone;
        }
    }
    return currentTouchView;
}

@end
