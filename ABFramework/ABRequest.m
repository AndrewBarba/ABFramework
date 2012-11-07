//
//  ABRequest.m
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABRequest.h"

@implementation ABRequest

/*** STATIC REQUEST METHODS ***/

+(void)reqeustToURL:(NSURL *)url
       onCompletion:(RequestCompletionHandler)complete
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
       onCompletion:(RequestCompletionHandler)complete
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
              onCompletion:(RequestCompletionHandler)complete
{
    [ABRequest reqeustToURL:[NSURL URLWithString:path] withData:data onCompletion:complete];
}

+(void)requestGETWithData:(NSDictionary *)data
                   toPath:(NSString *)path
             onCompletion:(RequestCompletionHandler)complete
{
    __block NSString *fullPath = [NSString stringWithFormat:@"%@?",path];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
        key = [key URLEncode];
        value = [value URLEncode];
        fullPath = [fullPath stringByAppendingFormat:@"&%@=%@",key,value];
    }];
    [ABRequest reqeustToURL:[NSURL URLWithString:fullPath] onCompletion:complete];
}
@end
