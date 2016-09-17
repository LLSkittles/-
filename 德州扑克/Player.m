//
//  Player.m
//  德州扑克
//
//  Created by Chao on 16/9/13.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import "Player.h"
#import "CardsManager.h"

@interface Player ()

@property (nonatomic, strong) NSMutableArray *baseCards;

@end

@implementation Player

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _baseCards = [[NSMutableArray alloc] initWithCapacity:2];
        
        self.contentSize = CGSizeMake(73 * 2, 98);
        
        for (int i = 0; i < 2; i++) {
            
            Card *card = [[CardsManager shareInstance] getRandomCard];
            [_baseCards addObject:card];
            card.anchorPoint = CGPointZero;
            card.position = CGPointMake(i * card.boundingBox.size.width, 0);
            [self addChild:card];
            
            [card setFrontWithAnimation:YES];
        }
    }
    return self;
}

- (NSArray *)getBaseCards{
    
    return [self.baseCards copy];
}

@end
