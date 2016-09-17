//
//  Card.h
//  德州扑克
//
//  Created by Chao on 16/9/13.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum : NSUInteger {
    spades = 0,
    hearts,
    clubs,
    diamonds,
} cardType;

@interface Card : CCNodeColor

@property (nonatomic, assign) cardType      type;
@property (nonatomic, assign) NSString      *number;
@property (nonatomic, assign) BOOL          isBack;

- (id)initWithType:(cardType)type andNumber:(NSString *)number isBack:(BOOL)bBack;
- (void)setFrontWithAnimation:(BOOL)b;
+ (Card *)copyCard:(Card *)card;

@end
