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
@synthesize backgroundImage;
@synthesize segmentPosition;

- (void)setContentView:(id)newContentView {
    NSParameterAssert([newContentView isKindOfClass:[UIView class]]);
    [contentView removeFromSuperview];
    [self addSubview:newContentView];
    contentView = newContentView;
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setOpaque:NO];
}


- (void)setBackgroundImage:(UIImage *)newBackgroundImage {
    [newBackgroundImage retain];
    [backgroundImage release];
    backgroundImage = newBackgroundImage;
    [self setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)dealloc {
    [backgroundImage release];
    [super dealloc];
}


- (void)drawRect:(CGRect)rect {
    if (backgroundImage) {
        rect = self.bounds;
        switch (segmentPosition) {
            case IKSegmentPositionLeft:
                rect.origin.x -= backgroundImage.leftCapWidth;
                rect.size.width += backgroundImage.leftCapWidth;
                break;
            case IKSegmentPositionRight:
                rect.size.width += backgroundImage.size.width - (backgroundImage.leftCapWidth + 1);
        }
        [backgroundImage drawInRect:rect];
    }
}


- (CGSize)sizeThatFits:(CGSize)size {
    size = [contentView sizeThatFits:size];
    if (width != 0.0f) {
        size.width = width;
    }
    return size;
}


@end
