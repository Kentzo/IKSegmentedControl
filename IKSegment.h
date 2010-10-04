//
//  IKSegment.h
//  IKSegment
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.


@interface IKSegment : UIView {
    id contentView;
    CGFloat width;
}

@property (nonatomic, retain) id contentView;
@property (nonatomic) CGFloat width;

@end
