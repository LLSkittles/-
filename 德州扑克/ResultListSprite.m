//
//  ResultListSprite.m
//
//  Created by : Chao
//  Project    : 德州扑克
//  Date       : 16/9/16
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ResultListSprite.h"
#import "Card.h"

// -----------------------------------------------------------------

@implementation ResultListSprite

- (id)initWithResultSet:(NSArray *)result{
    
    self = [super init];
    self.contentSize = CGSizeMake(73 * 5, 98);
    for (int i = 0 ;i < result.count; i++) {
        
        Card *c = [Card copyCard:result[i]];
        c.position = CGPointMake(i * c.boundingBox.size.width, 30);
        
        [self addChild:c];
    }

    return self;
}


@end





