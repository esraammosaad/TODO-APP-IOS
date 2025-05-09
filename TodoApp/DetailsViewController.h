//
//  DetailsViewController.h
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property TaskModel *task;
@property NSInteger index;

@end

NS_ASSUME_NONNULL_END
