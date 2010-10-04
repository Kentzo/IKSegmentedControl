//
//  IKSegment.h
//  IKSegment
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.


@interface IKSegment : UIView {
    UIView *contentView;
    CGFloat width;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic) CGFloat width;

@end
