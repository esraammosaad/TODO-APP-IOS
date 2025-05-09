//
//  taskModel.m
//  TodoApp
//
//  Created by Esraa Mohammed Mosaad on 23/04/2025.
//

#import "TaskModel.h"

@implementation TaskModel

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_taskDescription forKey:@"taskDescription"];
    [coder encodeObject:_status forKey:@"status"];
    [coder encodeObject:_priority forKey:@"priority"];
    [coder encodeObject:_startDate forKey:@"start"];
    [coder encodeObject:_reminderDate forKey:@"reminder"];
    [coder encodeObject:_statusImage forKey:@"image"];
     
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    
    if(self = [super init]){
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _taskDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"taskDescription"];
        _status = [coder decodeObjectOfClass:[NSString class] forKey:@"status"];
        _priority = [coder decodeObjectOfClass:[NSString class] forKey:@"priority"];
        _startDate = [coder decodeObjectOfClass:[NSString class] forKey:@"start"];
        _reminderDate = [coder decodeObjectOfClass:[NSString class] forKey:@"reminder"];
        _statusImage = [coder decodeObjectOfClass:[NSString class] forKey:@"image"];
    }
    return self;
    
}

+ (BOOL)supportsSecureCoding{
    
    return YES;
}

@end
