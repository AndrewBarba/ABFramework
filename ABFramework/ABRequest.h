//
//  ABRequest.h
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AB.h"

@interface ABRequest : NSObject
+(void)reqeustToURL:(NSURL *)url onCompletion:(RequestCompletionHandler)complete;
+(void)reqeustToURL:(NSURL *)url withData:(id)data onCompletion:(RequestCompletionHandler)complete;
+(void)requestGETWithData:(NSDictionary *)data toPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete;
+(void)requestPOSTWithData:(NSDictionary *)data toPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete;
@end
