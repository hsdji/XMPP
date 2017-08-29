//
//  cus.m
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "cus.h"

@implementation cus

-(void)drawTextInRect:(CGRect)rect{
    
    CGRect frame = CGRectMake(rect.origin.x + 10, rect.origin.y + 5, rect.size.width -15, rect.size.height -10);
    [super drawTextInRect:frame];
    
}

@end
