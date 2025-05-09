//
//  taskModel.h
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject<NSCoding,NSSecureCoding>
@property NSString *title;
@property NSString *taskDescription;
@property NSString *priority;
@property NSString *status;
@property NSString *startDate;
@property NSString *reminderDate;
@property NSString *statusImage;

-(void)encodeWithCoder:(NSCoder *)coder;

@end

NS_ASSUME_NONNULL_END
