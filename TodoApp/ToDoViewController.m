//
//  ToDoViewController.m
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import "ToDoViewController.h"
#import "CustomCellController.h"
#import "DetailsViewController.h"
#import "TaskModel.h"

@interface ToDoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSUserDefaults *defaults;
@property NSSet *set;
@property NSMutableArray<TaskModel*> *tasksArray;
@property NSMutableArray<TaskModel*> *lowPriorityTasks;
@property NSMutableArray<TaskModel*> *meduimPriorityTasks;
@property NSMutableArray<TaskModel*> *highPriorityTasks;
@property UIImage *image;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property NSMutableArray<TaskModel*> *searchArray;
@property NSMutableArray<TaskModel*> *searchArrayLow;
@property NSMutableArray<TaskModel*> *searchArrayMedium;
@property NSMutableArray<TaskModel*> *searchArrayHigh;
@property bool isSearch;
@property NSString * searchString;



@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _defaults=[NSUserDefaults standardUserDefaults];
    _tasksArray=[NSMutableArray new];
    _lowPriorityTasks=[NSMutableArray new];
    _meduimPriorityTasks=[NSMutableArray new];
    _highPriorityTasks=[NSMutableArray new];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    NSData *data= [_defaults objectForKey:@"tasks"];
    _set=[NSSet setWithArray:@[[NSMutableArray class],[TaskModel class],[NSString class]]];
    _tasksArray=(NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:_set fromData:data error:nil];
    
    [_lowPriorityTasks removeAllObjects];
    [_highPriorityTasks removeAllObjects];
    [_meduimPriorityTasks removeAllObjects];
    [self updateSearchArray:_searchTextField.text];
    
    for(int i=0 ; i<_tasksArray.count ;i++){
        if([_tasksArray[i].priority isEqual:@"Low"]){
            [_lowPriorityTasks addObject:_tasksArray[i]];
        }else if ([_tasksArray[i].priority isEqual:@"High"]){
            [_highPriorityTasks addObject:_tasksArray[i]];
        }else{
            [_meduimPriorityTasks addObject:_tasksArray[i]];
        }
    }
    
    [self.tableView reloadData];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return _isSearch? _searchArrayLow.count: _lowPriorityTasks.count;
            break;
            
        case 1:
            return _isSearch?_searchArrayMedium.count: _meduimPriorityTasks.count;
            
        default:
            return _isSearch?_searchArrayHigh.count:_highPriorityTasks.count;
            break;
    }

}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    
       [self updateSearchArray:textField.text];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
       [self updateSearchArray:textField.text];
    
    
}

-(void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    [self updateSearchArray:textField.text];
}

-(void)updateSearchArray:(NSString *)searchText
{
    if(searchText.length==0)
    {
        _isSearch=false;
    }
    else
    {
        _isSearch=YES;
        _searchArray=[[NSMutableArray alloc]init];
        _searchArrayLow=[[NSMutableArray alloc]init];
        _searchArrayMedium=[[NSMutableArray alloc]init];
        _searchArrayHigh=[[NSMutableArray alloc]init];
        for(TaskModel *task in _tasksArray){
            if([task.title.lowercaseString containsString:searchText.lowercaseString] || [task.taskDescription.lowercaseString containsString:searchText.lowercaseString]){
                [_searchArray addObject:task];
                printf("%lu",_searchArray.count);
                if([task.priority isEqual:@"Low"]){
                    [_searchArrayLow addObject:task];
                }else if ([task.priority isEqual:@"High"]){
                    [_searchArrayHigh addObject:task];
                }else{
                    [_searchArrayMedium addObject:task];
                }
            }
        }
    }

    [self.tableView reloadData];
}
    


    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        CustomCellController *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:{
                _image=[UIImage imageNamed:@"11"];
                cell.title.text =_isSearch?_searchArrayLow[indexPath.row].title:_lowPriorityTasks[indexPath.row].title;
                cell.taskDescription.text =_isSearch?_searchArrayLow[indexPath.row].taskDescription: _lowPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_isSearch? _searchArrayLow[indexPath.row].startDate: _lowPriorityTasks[indexPath.row].startDate;
                break;
            }
            case 1:{
                _image=[UIImage imageNamed:@"22"];
                cell.title.text =_isSearch? _searchArrayMedium[indexPath.row].title : _meduimPriorityTasks[indexPath.row].title;    cell.taskDescription.text =_isSearch? _searchArrayMedium[indexPath.row].taskDescription :_meduimPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_isSearch? _searchArrayMedium[indexPath.row].startDate :_meduimPriorityTasks[indexPath.row].startDate;
                break;
            }
            default:{
                _image=[UIImage imageNamed:@"33"];
                cell.title.text =_isSearch? _searchArrayHigh[indexPath.row].title :_highPriorityTasks[indexPath.row].title;    cell.taskDescription.text =_isSearch? _searchArrayHigh[indexPath.row].taskDescription :_highPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_isSearch? _searchArrayHigh[indexPath.row].startDate :_highPriorityTasks[indexPath.row].startDate;
                break;
            }
        }
        return cell;
    }
    
    
    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        switch (section) {
            case 0:
                return @"Low Priority Tasks";
                break;
                
            case 1:
                return @"Medium Priority Tasks";
                break;
                
            default:
                return  @"High Priority Tasks";
                break;
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
        // Return NO if you do not want the specified item to be editable.
        return YES;
    }
    
    
    
    // Override to support editing the table view.
    - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are You Sure You Want To Delete This Task?" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                switch (indexPath.section) {
                    case 0:
                    {
                        if(self.isSearch){
                            [self.tasksArray removeObject:self.searchArrayLow[indexPath.row]];
                            [self.lowPriorityTasks removeObject:self.searchArrayLow[indexPath.row]];
                            [self.searchArrayLow removeObjectAtIndex:indexPath.row];
                            
                        }else{
                            
                            [self.tasksArray removeObject:self.lowPriorityTasks[indexPath.row]];
                            [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
                            
                        }
                        break;
                        
                    }
                    case 1:
                    {
                        
                        if(self.isSearch){
                            [self.tasksArray removeObject:self.searchArrayMedium[indexPath.row]];
                            [self.meduimPriorityTasks removeObject:self.searchArrayMedium[indexPath.row]];
                            [self.searchArrayMedium removeObjectAtIndex:indexPath.row];
                            
                        }else{
                            [self.tasksArray removeObject:self.meduimPriorityTasks[indexPath.row]];
                            [self.meduimPriorityTasks removeObjectAtIndex:indexPath.row];
                            
                        }
                        break;
                        
                    }
                        
                    default:{
                        if(self.isSearch){
                            [self.tasksArray removeObject:self.searchArrayHigh[indexPath.row]];
                            [self.highPriorityTasks removeObject:self.searchArrayHigh[indexPath.row]];
                            [self.searchArrayHigh removeObjectAtIndex:indexPath.row];
                        }else{
                            [self.tasksArray removeObject:self.highPriorityTasks[indexPath.row]];
                            [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
                            
                        }
                        break;
                        
                    }
                }
                
                NSData *archivedData=[NSKeyedArchiver archivedDataWithRootObject:self.tasksArray requiringSecureCoding:YES error:nil];
                [self.defaults setObject:archivedData forKey:@"tasks"];
                [self.defaults synchronize];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:action2];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        DetailsViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"details"];
        
        switch (indexPath.section) {
            case 0:{
                
                dvc.task=_isSearch?_searchArrayLow[indexPath.row]: _lowPriorityTasks[indexPath.row];
                dvc.index =  [_tasksArray indexOfObject:_isSearch?
                              _searchArrayLow[indexPath.row]
                                                       : _lowPriorityTasks[indexPath.row]];
                
                break;
                
            }
            case 1:{
                dvc.task=_isSearch? _searchArrayMedium[indexPath.row]: _meduimPriorityTasks[indexPath.row];
                dvc.index = [_tasksArray indexOfObject:_isSearch?
                                                      _searchArrayMedium[indexPath.row]: _meduimPriorityTasks[indexPath.row]];
                break;
                
            }
            default:{
                dvc.task=_isSearch? _searchArrayHigh[indexPath.row]: _highPriorityTasks[indexPath.row];
                dvc.index = [_tasksArray indexOfObject:_isSearch? _searchArrayHigh[indexPath.row]:_highPriorityTasks[indexPath.row]];
                break;
                
            }
        }
        
        
        [self.navigationController pushViewController:dvc animated:YES];
        
    }
    

    
    /*
     // Override to support rearranging the table view.
     - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
     // Return NO if you do not want the item to be re-orderable.
     return YES;
     }
     */
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    - (IBAction)onAddClicked:(id)sender {
        DetailsViewController *dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"details"];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
@end
