//
//  CardsManager.h
//  德州扑克
//
//  Created by Chao on 16/9/13.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CardsManager : NSObject

+ (id)shareInstance;
- (void)reset;
- (Card *)getRandomCard;

- (void)sortCards:(NSMutableArray *)array;

@end
