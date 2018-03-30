//
//  XCHTML.h
//  hktv
//
//  Created by czljcb on 2017/12/22.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSHTML : NSObject

- (void)getHtmlWithURL:(NSString *)urlString
                sucess:(void (^)(NSString *html))htmlBlock
                 error:(void (^)( NSError *error))errorBlock;
- (void)getRequest :(NSString *)urlString
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

+ (instancetype)sharedInstance;

@property(nonatomic, copy)NSString *userAgent;

@end
