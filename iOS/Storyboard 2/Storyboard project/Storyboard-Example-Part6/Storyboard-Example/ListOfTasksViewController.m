
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
@synthesize currentSession;

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
    receivedCount = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
	[peers release];
    [listOfDONETasks release];
    [listOfTODOTasks release];
    [super dealloc];
}


#pragma mark Segue
-(void) setSession{
    // Initialize connector
    devicePicker = [[GKPeerPickerController alloc] init];
	devicePicker.delegate = self;
	devicePicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	peers = [[NSMutableArray alloc] init];
    
    //Show the connector
	[devicePicker show];
}


#pragma mark Task actions

-(void) ReceiveTask:(NSDictionary*)aTask{
    [listOfTODOTasks addObject:aTask];
    [self drawTables];
    [self sendData];
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
    // Create item as a UIButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + (25*(itemIndex+0)), view.frame.size.width, 25)];
    button.tag = itemIndex;
    [button setBackgroundImage:[UIImage imageNamed:@"CellBackground.png"] forState:UIControlStateNormal];
    
    // Add event for item
    [button setTitle:taskName forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageTouched:withEvent:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(imageTouchEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // add item to view
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       [dragAndDropTablesContainer addSubview:button];
    }completion:^(BOOL done){

    }];
}

- (void) imageTouched:(id) sender withEvent:(UIEvent *) event{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIButton* control = (UIButton*)sender;
    currentTouchView = [self dragInView:point];
    currentTouchingItemIndex = control.tag;
}

- (void) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIControl *control = sender;
    control.center = point;
}

- (void) imageTouchEnded:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dragAndDropTablesContainer];
    UIButton* control = (UIButton*)sender;
    NSString* inView = [self dragInView:point];
    
    if (![currentTouchView isEqualToString:inView]) {
        if ([inView isEqualToString:kViewDone]) {
            [listOfDONETasks addObject:[listOfTODOTasks objectAtIndex:currentTouchingItemIndex]];
            [listOfTODOTasks removeObjectAtIndex:currentTouchingItemIndex];
        } else if ([inView isEqualToString:kViewTodo]){
            [listOfTODOTasks addObject:[listOfDONETasks objectAtIndex:currentTouchingItemIndex]];
            [listOfDONETasks removeObjectAtIndex:currentTouchingItemIndex];
        }
        //Using uiview animation
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [control setFrame:[self snapItemOnCorrectPositionIndex:currentTouchingItemIndex inView:[inView isEqualToString:kViewTodo] ? todoTaskHolderView : doneTaskHolderView ]];
            }completion:^(BOOL done){
                [self drawTables];
                currentTouchingItemIndex = -1;
                currentTouchView = @"nil";
                [self sendData];
            }];
    } else { // Move the item back if there's no change
         [control setFrame:[self snapItemOnCorrectPositionIndex:currentTouchingItemIndex inView:[inView isEqualToString:kViewTodo] ? todoTaskHolderView : doneTaskHolderView ]];
    }
}

-(CGRect) snapItemOnCorrectPositionIndex:(int)itemIndex inView:(UIImageView*)view{
    CGRect correctFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y + (25*(itemIndex+0)), view.frame.size.width, 25);
    return correctFrame;
}

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

#pragma mark Send/Receive/Save data
-(void) sendData{
    //Send data to other peer
    NSData* todoData = [NSKeyedArchiver archivedDataWithRootObject:listOfTODOTasks];
	[currentSession sendData:todoData toPeers:peers withDataMode:GKSendDataReliable error:nil];
    NSData* doneData = [NSKeyedArchiver archivedDataWithRootObject:listOfDONETasks];
	[currentSession sendData:doneData toPeers:peers withDataMode:GKSendDataReliable error:nil];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    // Read the bytes in data and perform an application-specific action.
	NSMutableArray* receivedMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (receivedCount == 0) {
        [listOfTODOTasks release];
        listOfTODOTasks = [[NSMutableArray alloc] initWithArray:receivedMutableArray copyItems:YES];
        receivedCount++;
    }
    else if (receivedCount == 1){
        [listOfDONETasks release];
        listOfDONETasks = [[NSMutableArray alloc] initWithArray:receivedMutableArray copyItems:YES];
        receivedCount = 0;
    }
    [self drawTables];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"GoHomeSegue"])
	{
        [[NSUserDefaults standardUserDefaults] setObject:listOfTODOTasks forKey:kDataTodoKey];
        [[NSUserDefaults standardUserDefaults] setObject:listOfDONETasks forKey:kDataDoneKey];
	}
}

#pragma mark PeerPickerControllerDelegate
/* Notifies delegate that the connection type is requesting a GKSession object.
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	NSString *txt = @"Other device";
	GKSession* aSession = [[GKSession alloc] initWithSessionID:@"gavi" displayName:txt sessionMode:GKSessionModePeer];
    [aSession autorelease];
    return aSession;
}
/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    
	NSLog(@"Connected from %@",peerID);
    
	// Use a retaining property to take ownership of the session.
    self.currentSession = session;
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
    
    // Loading Data when devices are connected.
    NSArray* todoArray = [[NSUserDefaults standardUserDefaults] objectForKey:kDataTodoKey];
    if(todoArray) {
        [listOfTODOTasks release];
        listOfTODOTasks = [[NSMutableArray alloc] initWithArray:todoArray];
    }
    
    NSArray* doneArray = [[NSUserDefaults standardUserDefaults] objectForKey:kDataDoneKey];
    if(doneArray) {
        [listOfDONETasks release];
        listOfDONETasks = [[NSMutableArray alloc] initWithArray:doneArray];
    }
    NSLog(@"Load data...");
    if ([listOfTODOTasks count] != 0 || [listOfTODOTasks count] != 0) {
        [self drawTables];
        [self sendData];
    }
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    NSLog(@"Cancel!");
}

#pragma mark GameSessionDelegate

/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
	switch (state)
    {
        case GKPeerStateConnected:
		{
            [peers addObject:peerID];
			NSLog(@"%@",[NSString stringWithFormat:@"%@%@",@"Connected from pier ",peerID]);
			break;
		}
        case GKPeerStateDisconnected:
		{
			[peers removeObject:peerID];
			NSLog(@"%@",[NSString stringWithFormat:@"%@%@",@"Disconnected from pier ",peerID]);
			break;
		}
    }
}


@end
