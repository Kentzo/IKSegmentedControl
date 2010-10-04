//
//  IKSegment.m
//  IKSegment
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.

#import "IKSegment.h"


@implementation IKSegment
@synthesize contentView;
@synthesize width;

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    [self addSubview:newContentView];
    contentView = newContentView;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (CGSize)sizeThatFits:(CGSize)size {
    size = [contentView sizeThatFits:size];
    if (width != 0.0f) {
        size.width = width;
    }
    return size;
}


@end
