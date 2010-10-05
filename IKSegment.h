//
//  IKSegment.h
//  IKSegment
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.


typedef enum _IKSegmentPosition {
    IKSegmentPositionCenter,
    IKSegmentPositionLeft,
    IKSegmentPositionRight
} IKSegmentPosition;

@interface IKSegment : UIView {
}

@property (nonatomic, retain) id contentView;
@property (nonatomic) CGFloat width;
@property (nonatomic, retain) UIImage *backgroundImage;
/**
 @disctussion If backgroundImage is non-nil and position is either IKSegmentPositionLeft or IKSegmentPositionRight then 
 image is drawn so that to hide left/right cap.
 */
@property (nonatomic) IKSegmentPosition segmentPosition;

@end
