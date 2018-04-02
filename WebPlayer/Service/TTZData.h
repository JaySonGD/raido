//
//  TTZData.h
//  WebPlayer
//
//  Created by czljcb on 2018/4/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZData : NSObject
+ (NSDictionary *)loadDataFinish: (void(^)(NSDictionary *))block;
@end
