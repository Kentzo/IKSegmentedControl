//
//  IKSegmentedControl.h
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.


@class IKSeparators;

/*
 @discussion Default cornerRadius is 10.0f
 */
@interface IKSegmentedControl : UIControl {
    NSMutableArray *segments;
@private
    id _backgrounds[2];
    IKSeparators *_separators;
}

@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic, readonly) NSArray *segments;
/**
 @default [UIColor lightGrayColor]
 @discussion UIColor and UIImage are supported.
 */
@property (nonatomic, retain) id separator;
@property (nonatomic) BOOL separateSelectedItem; // default NO

- (id)initWithItems:(NSArray *)items;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment; // 0.0 width indicates that IKSegmentedControl should calc width itself. Otherwise width will be used
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

// UIColor and UIImage are supported.
// If object is class of UIImage then image is resized to fill IKSegment background.
// If object is class of UIColor then color is used as backgroundColor of IKSegment.
- (void)setBackgroundForNormalState:(id)normalBackground forSelectedState:(id)selectedBackground;
- (id)normalStateBackground;
- (id)selectedStateBackground;
@end
