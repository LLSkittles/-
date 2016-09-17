//
//  judgeManager.m
//  德州扑克
//
//  Created by Chao on 16/9/14.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import "judgeManager.h"
#import "Card.h"
#import "CardsManager.h"
#import "NSArray+toString.h"

@implementation judgeManager

//- (void)sortCards{
//    
//    self.cards = [[NSMutableArray alloc] initWithCapacity:5];
//   
//    Card *card1 = [[Card alloc] initWithType:1 andNumber:@"6" isBack:YES];
//    [self.cards addObject:card1];
//    Card *card2 = [[Card alloc] initWithType:3 andNumber:@"6" isBack:YES];
//    [self.cards addObject:card2];
//    Card *card3 = [[Card alloc] initWithType:2 andNumber:@"7" isBack:YES];
//    [self.cards addObject:card3];
//    Card *card4 = [[Card alloc] initWithType:0 andNumber:@"4" isBack:YES];
//    [self.cards addObject:card4];
//    Card *card5 = [[Card alloc] initWithType:1 andNumber:@"7" isBack:YES];
//    [self.cards addObject:card5];
//    
//    [self.cards sortUsingComparator:^NSComparisonResult(Card *obj1, Card *obj2) {
//        
//        if ([obj1.number intValue] > [obj2.number intValue]) {
//            return NSOrderedDescending;
//        }
//        else if ([obj1.number intValue] < [obj2.number intValue]){
//            return NSOrderedAscending;
//        }
//        else {
//            return NSOrderedSame;
//        }
//    }];
//    
//    [self validateNumber:@"2a333" withPattern:@"(\\w)\\1(\\w)\\2\\2"];
//}

+ (NSString *)juageCardsType:(NSMutableArray *)array{
    
    if ([self StraightFlush:array]) {
        
        return [self StraightFlush:array];
        
    }else if ([self FourCard:array]){
        
        return [self FourCard:array];
    
    }else if([self GourdCard:array]){
       
        return [self GourdCard:array];
        
    }else if ([self FlushCard:array]){
        
        return [self FlushCard:array];
   
    }else if ([self StraightCard:array]){
        
        return [self StraightCard:array];
        
    }else if([self ThreeCard:array]){
        
        return [self ThreeCard:array];
    
    }else if([self Double_TwoCard:array]){
        
        return [self Double_TwoCard:array];
   
    }else if ([self Double_OneCard:array]){
        
        return [self Double_OneCard:array];
    
    }else{
        
        return [self HighCard:array];
    }
}

+ (BOOL)validateNumber:(NSString *) textString withPattern:(NSString *)pattern
{
    NSError *error;
    // 创建NSRegularExpression对象并指定正则表达式
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:0
                                  error:&error];
    if (!error) { // 如果没有错误
        // 获取特特定字符串的范围
        NSTextCheckingResult *match = [regex firstMatchInString:textString
                                                        options:0
                                                          range:NSMakeRange(0, [textString length])];
        if (match) {
            // 截获特定的字符串
            NSString *result = [textString substringWithRange:match.range];
            NSLog(@"%@ match",result);
            
            return YES;
       
        }else{

            NSLog(@"not match");

            return NO;
        }
        
    } else { // 如果有错误，则把错误打印出来
        NSLog(@"error - %@", error);
        
        return NO;
    }
}

//同花顺
+ (NSString *)StraightFlush:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    Card *c = cards[0];
    
    for (int i = 1; i < cards.count; i++) {
        
        Card *a = cards[i];
        if (a.type == c.type && [a.number intValue] == ([c.number intValue] + 1)) {
            
            c = cards[i];
        
        }else if((i == cards.count - 1) && [c.number intValue] == 5 && [[(Card *)cards[i] number] intValue] == 14 && [(Card *)cards[i] type] == c.type){
            
            Card *temp = cards[i];
            [cards removeObject:temp];
            [cards insertObject:temp atIndex:0];
            
        }else{
            
            return nil;
        }
    }
    
    return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctStraightFlush, [cards toString]];
}

//四条
+ (NSString *)FourCard:(NSMutableArray *)cards{

    [[CardsManager shareInstance] sortCards:cards];
    
    Card *card1 = cards[0];
    Card *card4 = cards[3];
    
    Card *card2 = cards[1];
    Card *card5 = cards[4];
    
    if (([card1.number intValue] == [card4.number intValue]) || ([card2.number intValue] == [card5.number intValue])) {
        
        return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctFourCard, [cards toString]];
    
    }else{
        
        return nil;
    }
}

//葫芦
+ (NSString *)GourdCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    NSString *str = [cards toString];
    
    BOOL match1 = [self validateNumber:[str copy] withPattern:@"(\\w)\\1(\\w)\\2\\2"];
    BOOL match2 = [self validateNumber:[str copy] withPattern:@"(\\w)\\1\\1(\\w)\\2"];
    
    if (match1 || match2) {
        
        return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctGourdCard, [cards toString]];
    }else{
        return nil;
    }
}

//同花
+ (NSString *)FlushCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    Card *temp = cards[0];
    for (int i = 1; i < cards.count; i++) {
     
        Card *card = cards[i];
        if (temp.type == card.type) {
            
            temp = card;
        
        }else{
            
            return nil;
        }
    }

    return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctFlushCard, [cards toString]];
}

//顺子
+ (NSString *)StraightCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    Card *c = cards[0];
    
    for (int i = 1; i < cards.count; i++) {
        
        Card *a = cards[i];
        if ([a.number intValue] == ([c.number intValue] + 1)) {
            
            c = cards[i];
            
        }else if((i == cards.count - 1) && [c.number intValue] == 5 && [[(Card *)cards[i] number] intValue] == 14){
            
            Card *temp = cards[i];
            [cards removeObject:temp];
            [cards insertObject:temp atIndex:0];
            
        }else{
            
            return nil;
        }
    }
    
    return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctStraightCard, [cards toString]];
}

//三条
+ (NSString *)ThreeCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    NSString *str = [cards toString];
    
    BOOL match = [self validateNumber:[str copy] withPattern:@"(\\w*)(\\w)\\2\\2(\\w*)"];

    if (match) {

        return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctThreeCard, [cards toString]];
    }else{
        
        return nil;
    }
}

//两对
+ (NSString *)Double_TwoCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    NSString *str = [cards toString];
    
    BOOL match1 = [self validateNumber:[str copy] withPattern:@"(\\w*)(\\w)\\2(\\w)\\3(\\w*)"];
    BOOL match2 = [self validateNumber:[str copy] withPattern:@"(\\w)\\1(\\w)(\\w)\\3"];
    
    if (match1 || match2) {
        
        return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctDouble_TwoCard, [cards toString]];
    }else{
        
        return nil;
    }
}

//一对
+ (NSString *)Double_OneCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    NSString *str = [cards toString];
    
    BOOL match = [self validateNumber:[str copy] withPattern:@"(\\w*)(\\w)\\2(\\w*)"];
    if (match) {
        
        return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctDouble_OneCard, [cards toString]];
    
    }else{
        
        return nil;
    }
}

//高牌
+ (NSString *)HighCard:(NSMutableArray *)cards{
    
    [[CardsManager shareInstance] sortCards:cards];

    return [NSString stringWithFormat:@"0x%lu%@",  (unsigned long)ctHighCard, [cards toString]];
}

@end
