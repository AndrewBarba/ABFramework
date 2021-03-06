//
//  ABRequest.m
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABRequest.h"
#import "NSString+AB.h"

@implementation ABRequest

/*** STATIC REQUEST METHODS ***/

+(void)reqeustToURL:(NSURL *)url
       onCompletion:(RequestHandler)complete
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                            timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (complete) complete(output,data,error);
    }];
}

+(void)reqeustToURL:(NSURL *)url
           withData:(id)data
       onCompletion:(RequestHandler)complete
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                            timeoutInterval:10];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if (complete) complete(output,data,error);
                           }];
}

+(void)requestPOSTWithData:(NSDictionary *)data
                    toPath:(NSString *)path
              onCompletion:(RequestHandler)complete
{
    NSLog(@"%@",path);
    [ABRequest reqeustToURL:[NSURL URLWithString:path] withData:data onCompletion:complete];
}

+(void)requestGETWithData:(NSDictionary *)data
                   toPath:(NSString *)path
             onCompletion:(RequestHandler)complete
{
    __block NSString *fullPath = [NSString stringWithFormat:@"%@?",path];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
        key = [key encodeForURL];
        value = [value encodeForURL];
        fullPath = [fullPath stringByAppendingFormat:@"&%@=%@",key,value];
    }];
    NSLog(@"%@",fullPath);
    [ABRequest reqeustToURL:[NSURL URLWithString:fullPath] onCompletion:complete];
}
@end
