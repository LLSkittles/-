//
//  NSArray+toString.m
//  德州扑克
//
//  Created by Chao on 16/9/15.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import "NSArray+toString.h"
#import "Card.h"

@implementation NSArray (toString)

- (NSString *)toString{
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:5];
    for (Card *card in self) {
        
        NSString *number = card.number;
        NSString *strNum = nil;
        int num = [number intValue];
        switch (num) {
            case 10:
                strNum = @"a";
                break;
            case 11:
                strNum = @"b";
                break;
            case 12:
                strNum = @"c";
                break;
            case 13:
                strNum = @"d";
                break;
            case 14:
                strNum = @"e";
                break;
            default:
                strNum = number;
                break;
        }
        
        [str appendString:strNum];
    }

    return [str copy];
}

@end
