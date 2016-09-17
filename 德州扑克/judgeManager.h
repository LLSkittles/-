//
//  judgeManager.h
//  德州扑克
//
//  Created by Chao on 16/9/14.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    ctNoneCard = 0,
    ctHighCard,      //高牌
    ctDouble_OneCard,//一对
    ctDouble_TwoCard,//二对
    ctThreeCard,     //三条
    ctStraightCard,  //顺子
    ctFlushCard,     //同花
    ctGourdCard,     //三条加对子（葫芦）
    ctFourCard,      //四条
    ctStraightFlush, //同花顺
    ctRoyalFlush     //皇家同花顺
    
} CardsTypeEnum;


@interface judgeManager : NSObject

+ (NSString *)juageCardsType:(NSMutableArray *)array;

@end
