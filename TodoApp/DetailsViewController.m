//
//  DetailsViewController.m
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import "DetailsViewController.h"
#import "TaskModel.h"
#import <UserNotifications/UserNotifications.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityController;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateAndTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *statusTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusController;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property NSUserDefaults *defaults;
@property NSMutableArray *tasksArray;
@property NSMutableArray *inProgressArray;
@property NSMutableArray *doneArray;
@property NSSet *set;
@property bool isGranted;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;




@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _descriptionTextView.layer.borderWidth = 0.5;
    _descriptionTextView.layer.cornerRadius = 8.0;
    _descriptionTextView.clipsToBounds = YES;
    
    _titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleTextField.layer.borderWidth = 0.5;
    _titleTextField.layer.cornerRadius = 8.0;
    _titleTextField.clipsToBounds = YES;
    [_dateAndTimePicker setMinimumDate:[NSDate date]];
    [_startDatePicker setMinimumDate:[NSDate date]];
    _isGranted=false;
    UNUserNotificationCenter *center =[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options=UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self.isGranted=granted;
    }];
    _defaults=[NSUserDefaults standardUserDefaults];
    NSData *data= [_defaults objectForKey:@"tasks"];
    NSData *inProgressTasksData= [_defaults objectForKey:@"inProgress"];
    NSData *doneTasksData= [_defaults objectForKey:@"done"];
    _set=[NSSet setWithArray:@[[NSMutableArray class],[TaskModel class],[NSString class]]];
    _tasksArray=(NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:_set fromData:data error:nil];
    _inProgressArray=(NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:_set fromData:inProgressTasksData error:nil];
    _doneArray=(NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:_set fromData:doneTasksData error:nil];
    if (_tasksArray == nil ) {
            _tasksArray = [NSMutableArray new];
        }
    if (_inProgressArray == nil ) {
            _inProgressArray = [NSMutableArray new];
        }
    if (_doneArray == nil ) {
            _doneArray = [NSMutableArray new];
        }
    
    if(_task==nil){
        [_statusTitle setHidden:YES];
        [_statusController setHidden:YES];
    }else{
        _screenTitle.text=@"Edit Task";
        _titleTextField.text=_task.title;
        _descriptionTextView.text=_task.taskDescription;
        [_detailsButton setTitle:@"Edit" forState:UIControlStateNormal];
        if([_task.priority isEqual:@"Low"]){
            [_priorityController setSelectedSegmentIndex:0];
            
        }else if([_task.priority isEqual:@"High"]){
            [_priorityController setSelectedSegmentIndex:2];
            
        }else{
            [_priorityController setSelectedSegmentIndex:1];
        }
        
        if([_task.status isEqual:@"TODO"]){
            [_statusController setSelectedSegmentIndex:0];
            
        }else if([_task.status isEqual:@"done"]){
            _screenTitle.text=@"View Task";
            [_detailsButton setHidden:YES];
            [_statusController setSelectedSegmentIndex:2];
            [_statusController setEnabled:NO forSegmentAtIndex:0];
            [_statusController setEnabled:NO forSegmentAtIndex:1];
            
        }else{
            [_statusController setSelectedSegmentIndex:1];
            [_statusController setEnabled:NO forSegmentAtIndex:0];
        }
        NSLog(@"%@",_task.startDate);
        NSLog(@"%@",_task.reminderDate);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM dd, yyyy hh:mm a"];
        NSDate *reminder = [dateFormat dateFromString:_task.reminderDate];
        NSDate *start = [dateFormat dateFromString:_task.startDate];
        [_dateAndTimePicker setDate:reminder animated:YES];
        [_startDatePicker setDate:start animated:YES];
        NSLog(@"%@",start);
        NSLog(@"%@",reminder);
    
        [_titleTextField setEnabled:NO];
        [_descriptionTextView setEditable:NO];
        [_priorityController setEnabled:NO];
        [_statusController setEnabled:NO];
        [_dateAndTimePicker setEnabled:NO];
        [_startDatePicker setEnabled:NO];
        [_reminderButton setEnabled:NO];
 
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onDetailsButtonClicked:(id)sender {
    if(![_detailsButton.titleLabel.text isEqual:@"Edit"]){
        
        if([_titleTextField.text isEqual:@""] || [_descriptionTextView.text isEqual:@""]){
            [self showAlert:@"Please Fill All Task Details"];
        }else{
            TaskModel *task=[TaskModel new];
            task.title=_titleTextField.text;
            task.taskDescription=_descriptionTextView.text;
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            formatter. dateFormat = @"MMMM dd, yyyy hh:mm a";
            task.startDate = [formatter stringFromDate:[_startDatePicker date]];
            task.reminderDate=[formatter stringFromDate:[_dateAndTimePicker date]];
               
            
            switch (_priorityController.selectedSegmentIndex ) {
                case 0:
                    task.priority=@"Low";
                    task.statusImage=@"11";
                    break;
                case 1:
                    task.priority=@"Medium";
                    task.statusImage=@"22";
                    break;
                case 2:
                    task.priority=@"High";
                    task.statusImage=@"33";
                    break;
                    
                default:
                    task.priority=@"Low";
                    task.statusImage=@"11";
                    break;
            }
                
          switch (_statusController.selectedSegmentIndex ) {
                case 0:
                    task.status=@"TODO";
                    break;
                case 1:
                    task.status=@"inProgress";
                    break;
                case 2:
                    task.status=@"done";
                    break;
                    
                default:
                    task.priority=@"TODO";
                    break;
            }
            if(_task == nil){
                [_tasksArray addObject:task];
            }else{
                if([_task.status isEqual:@"TODO"]){
                    
                    [_tasksArray removeObjectAtIndex:_index];
                    
                }else if([_task.status isEqual:@"inProgress"]){
                    
                    [_inProgressArray removeObjectAtIndex:_index];
                    
                }else{
                    [_doneArray removeObjectAtIndex:_index];
                }
                
                if([task.status isEqual:@"TODO"]){
                    [_tasksArray insertObject:task atIndex:_index];
                    
                }else if([task.status isEqual:@"inProgress"]){
                    if([_task.status isEqual:@"inProgress"]){
                        [_inProgressArray insertObject:task atIndex:_index];
                    }else{
                        [_inProgressArray addObject:task ];
                    }
                }else{
                    if([_task.status isEqual:@"done"]){
                        [_doneArray insertObject:task atIndex:_index];
                    }else{
                        [_doneArray addObject:task ];
                    }
                }
            }
            NSData *archivedDataInProgress=[NSKeyedArchiver archivedDataWithRootObject:_inProgressArray requiringSecureCoding:YES error:nil];
                [_defaults setObject:archivedDataInProgress forKey:@"inProgress"];
           NSData *archivedDataDone=[NSKeyedArchiver archivedDataWithRootObject:_doneArray requiringSecureCoding:YES error:nil];
                [_defaults setObject:archivedDataDone forKey:@"done"];
            NSData *archivedData=[NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:nil];
            [_defaults setObject:archivedData forKey:@"tasks"];
            [_defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [_titleTextField setEnabled:YES];
        [_descriptionTextView setEditable:YES];
        [_priorityController setEnabled:YES];
        [_statusController setEnabled:YES];
        [_dateAndTimePicker setEnabled:YES];
        [_startDatePicker setEnabled:YES];
        [_reminderButton setEnabled:YES];
        [_detailsButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

-(void)showAlert:(NSString*)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (IBAction)onAddReminderClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You Sure You Want A Reminder?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.isGranted){
            NSTimeInterval interval = [self.dateAndTimePicker.date timeIntervalSinceNow];
            if(interval>0){
                UNUserNotificationCenter *center =[UNUserNotificationCenter currentNotificationCenter];
                UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc] init];
                content.title=@"Task Reminder";
                if([self.titleTextField.text isEqual:@""]||[self.descriptionTextView.text isEqual:@""]){
                    [self showAlert:@"Please Fill All Task Details First"];
                  
                    
                }else{
                    content.subtitle=self.titleTextField.text;
                    content.body=self.descriptionTextView.text;
                }
                content.sound=[UNNotificationSound defaultSound];
                UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
                UNNotificationRequest *request=[UNNotificationRequest requestWithIdentifier:@"localNotification" content:content trigger:trigger];
                [center addNotificationRequest:request withCompletionHandler:nil];
            }else{
                [self showAlert:@"Reminder Can't Set In the past"];
            }
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    

}

@end
