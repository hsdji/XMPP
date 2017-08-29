//
//  mianTableViewCell.m
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "mianTableViewCell.h"

@implementation mianTableViewCell

-(cus *)message
{
    if (!_message) {
        _message = [cus new];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main"]];
        image.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 0, 40, 40);
        [self.contentView addSubview:image];
        _message.font = [UIFont systemFontOfSize:14];
        _message.layer.cornerRadius = 10;
        _message.clipsToBounds = YES;
        _message.backgroundColor = [UIColor greenColor];
        _message.numberOfLines = 0;
        
        [self.contentView addSubview:_message];
    }
    return _message;
}




@end
