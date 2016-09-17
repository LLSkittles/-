//
//  CardsManager.m
//  德州扑克
//
//  Created by Chao on 16/9/13.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import "CardsManager.h"
#import "cocos2d.h"

@interface CardsManager ()

@property (nonatomic, strong) NSMutableArray *allCards;

@end


@implementation CardsManager

+ (id)shareInstance{
    
    static CardsManager *sharedManager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[CardsManager alloc] init];
    });
 
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self reset];
    }
    return self;
}

- (void)reset{
    
    _allCards = [[NSMutableArray alloc] initWithCapacity:52];
    [_allCards removeAllObjects];
    
    for (int i = 0; i < 4; i++) {
        
        for (int j = 2; j < 15; j++) {
            
            Card *card = [[Card alloc] initWithType:i andNumber:[NSString stringWithFormat:@"%d", j] isBack:YES];
            [_allCards addObject:card];
        }
    }
    
}

- (Card *)getRandomCard{
    
    NSInteger index = arc4random() % (_allCards.count);
    
    Card *card = _allCards[index];
    [_allCards removeObject:card];
    
    return card;
}

- (void)sortCards:(NSMutableArray *)array{
    
    [array sortUsingComparator:^NSComparisonResult(Card *obj1, Card *obj2) {
        
        if ([obj1.number intValue] > [obj2.number intValue]) {
            return NSOrderedDescending;
        }
        else if ([obj1.number intValue] < [obj2.number intValue]){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
}

@end
