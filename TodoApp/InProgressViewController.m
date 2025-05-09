//
//  InProgressViewController.m
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import "InProgressViewController.h"
#import "CustomCellController.h"
#import "TaskModel.h"
#import "DetailsViewController.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSUserDefaults *defaults;
@property NSMutableArray<TaskModel*> *inProgressTasksArray;
@property NSMutableArray<TaskModel*> *lowPriorityTasks;
@property NSMutableArray<TaskModel*> *meduimPriorityTasks;
@property NSMutableArray<TaskModel*> *highPriorityTasks;
@property NSSet *set;
@property UIImage *image;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property bool isFiltered;


@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _defaults=[NSUserDefaults standardUserDefaults];
    _inProgressTasksArray=[NSMutableArray new];
    _lowPriorityTasks=[NSMutableArray new];
    _meduimPriorityTasks=[NSMutableArray new];
    _highPriorityTasks=[NSMutableArray new];
    _isFiltered=false;
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    NSData *data= [_defaults objectForKey:@"inProgress"];
    _set=[NSSet setWithArray:@[[NSMutableArray class],[TaskModel class],[NSString class]]];
    _inProgressTasksArray=(NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:_set fromData:data error:nil];
    
    [_lowPriorityTasks removeAllObjects];
    [_highPriorityTasks removeAllObjects];
    [_meduimPriorityTasks removeAllObjects];
    
    for(int i=0 ; i<_inProgressTasksArray.count ;i++){
        if([_inProgressTasksArray[i].priority isEqual:@"Low"]){
            [_lowPriorityTasks addObject:_inProgressTasksArray[i]];
        }else if ([_inProgressTasksArray[i].priority isEqual:@"High"]){
            [_highPriorityTasks addObject:_inProgressTasksArray[i]];
        }else{
            [_meduimPriorityTasks addObject:_inProgressTasksArray[i]];
        }
    }
//    if(_inProgressTasksArray.count==0){
//
//        UIImage *image = [UIImage imageNamed:@"333"];
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//
//            // Add image view on top of table view
//           // [self.tableView addSubview:imageView];
//
//            // Set the background view of the table view
//            self.tableView.backgroundView = imageView;
//
//    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _isFiltered?3:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_isFiltered){
        switch (section) {
            case 0:
                return _lowPriorityTasks.count;
                break;
            
            case 1:
                return _meduimPriorityTasks.count;
                break;
                
            default:
                return _highPriorityTasks.count;
                break;
        }
    }else{
        
        return _inProgressTasksArray.count;
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(_isFiltered){
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
        
    }else{
        return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellController *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(_isFiltered){
        
        switch (indexPath.section) {
            case 0:{
                _image=[UIImage imageNamed:_lowPriorityTasks[indexPath.row].statusImage];
                cell.title.text =_lowPriorityTasks[indexPath.row].title;    cell.taskDescription.text =_lowPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_lowPriorityTasks[indexPath.row].startDate;
                break;
                
            }
            case 1:{
                _image=[UIImage imageNamed:_meduimPriorityTasks[indexPath.row].statusImage];
                cell.title.text =_meduimPriorityTasks[indexPath.row].title;    cell.taskDescription.text =_meduimPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_meduimPriorityTasks[indexPath.row].startDate;
                break;
                
            }
            default:{
                _image=[UIImage imageNamed:_highPriorityTasks[indexPath.row].statusImage];
                cell.title.text =_highPriorityTasks[indexPath.row].title;    cell.taskDescription.text =_highPriorityTasks[indexPath.row].taskDescription;
                [cell.image setImage:_image];
                cell.date.text=_highPriorityTasks[indexPath.row].startDate;
                break;
            }
        }
    }else{
        _image=[UIImage imageNamed:_inProgressTasksArray[indexPath.row].statusImage];
        cell.title.text =_inProgressTasksArray[indexPath.row].title;    cell.taskDescription.text =_inProgressTasksArray[indexPath.row].taskDescription;
        [cell.image setImage:_image];
        cell.date.text=_inProgressTasksArray[indexPath.row].startDate;
    }
        
    return cell;
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
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
            if(self.isFiltered){
                switch (indexPath.section) {
                    case 0:{
                        [self.inProgressTasksArray removeObject:self.lowPriorityTasks[indexPath.row]];
                        [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                        
                    }
                    case 1:{
                        [self.inProgressTasksArray removeObject:self.meduimPriorityTasks[indexPath.row]];
                        [self.meduimPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                        
                    }
                        
                    default:{
                        [self.inProgressTasksArray removeObject:self.highPriorityTasks[indexPath.row]];
                        [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                        
                    }
                }
                
            }else{
                [self.inProgressTasksArray removeObjectAtIndex:indexPath.row];
            }
            NSData *archivedData=[NSKeyedArchiver archivedDataWithRootObject:self.inProgressTasksArray requiringSecureCoding:YES error:nil];
            [self.defaults setObject:archivedData forKey:@"inProgress"];
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
    
    if(_isFiltered){
        
        switch (indexPath.section) {
            case 0:
            {
                dvc.task=_lowPriorityTasks[indexPath.row];
                dvc.index=[_inProgressTasksArray indexOfObject:_lowPriorityTasks[indexPath.row]];
                break;
            }
            
            case 1:
            {
                dvc.task=_meduimPriorityTasks[indexPath.row];
                dvc.index=[_inProgressTasksArray indexOfObject:_meduimPriorityTasks[indexPath.row]];

                break;
                
            }
                
            default:
                dvc.task=_highPriorityTasks[indexPath.row];
                dvc.index=[_inProgressTasksArray indexOfObject:_highPriorityTasks[indexPath.row]];
                break;
        }
    }else{
        dvc.task=_inProgressTasksArray[indexPath.row];
        dvc.index=indexPath.row;
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
- (IBAction)onFilterButtonClicked:(id)sender {
    
    _isFiltered=!_isFiltered;
    if(_isFiltered){
        [_filterButton setTitle:@"Remove Filter"];
    }else{
        [_filterButton setTitle:@"Filter"];
    }
    [_tableView reloadData];
    
}

@end
