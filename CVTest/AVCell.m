//
//  AVCell.m
//  CVTest
//
//  Created by jichao on 2016/11/1.
//  Copyright © 2016年 jichao. All rights reserved.
//

#import "AVCell.h"

@interface AVCell ()
@property UILabel* numberLabel;
@end

@implementation AVCell
- (AVCell*)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.numberLabel = [[UILabel alloc] init];
        [self.numberLabel setFont:[UIFont systemFontOfSize:12]];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.frame = CGRectMake(0, 0, frame.size.width, 20);
        [self addSubview:self.numberLabel];
//        self.numberLabel.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setIndex:(int)index
{
    self.numberLabel.text = [NSString stringWithFormat:@"%u", index];
//    [self setNeedsDisplay];
}

@end
