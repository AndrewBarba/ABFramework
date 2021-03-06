//
//  NSString+AB.h
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequired.h"

@interface NSString (AB)
-(id)JSON;
-(NSString *)encodeForURL;
-(NSString *)strip;
-(BOOL)isEmpty;
-(NSDate *)dateWithFormat:(NSString *)format;
-(NSDate *)SQLTimestamp;
@end
