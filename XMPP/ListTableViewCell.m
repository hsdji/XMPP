//
//  ListTableViewCell.m
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell
-(cus *)nameLab
{
    if (!_nameLab) {
        _nameLab = [cus new];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other"]];
        image.frame = CGRectMake(20, self.contentView.frame.size.height/2-20, 40, 40);
        image.layer.cornerRadius = 20;
        image.clipsToBounds = YES;
        [self.contentView addSubview:image];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.layer.cornerRadius = 10;
        _nameLab.clipsToBounds = YES;
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.numberOfLines = 0;
        _nameLab.frame = CGRectMake(80, self.contentView.frame.size.height/2-17.5, [UIScreen mainScreen].bounds.size.width-100, 35);
        [self.contentView addSubview:_nameLab];
    }
    return _nameLab;
}





@end
