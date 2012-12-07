//
//  ABRequest.h
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequired.h"

@interface ABRequest : NSObject
+(void)reqeustToURL:(NSURL *)url onCompletion:(RequestHandler)complete;
+(void)reqeustToURL:(NSURL *)url withData:(id)data onCompletion:(RequestHandler)complete;
+(void)requestGETWithData:(NSDictionary *)data toPath:(NSString *)path onCompletion:(RequestHandler)complete;
+(void)requestPOSTWithData:(NSDictionary *)data toPath:(NSString *)path onCompletion:(RequestHandler)complete;
@end
