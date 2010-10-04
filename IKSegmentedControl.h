//
//  IKSegmentedControl.h
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.

typedef enum _IKSegmentedControlStyle {
    IKSegmentedControlStyleColor,
    IKSegmentedControlStyleImage
} IKSegmentedControlStyle;


/*
 @discussion Default cornerRadius is 10.0f
 */
@interface IKSegmentedControl : UIControl {
    UIFont *font;
    IKSegmentedControlStyle style;
    NSInteger selectedSegmentIndex;
    NSMutableArray *segments;
@private
    id _background[2];
}

@property (nonatomic, retain) UIFont *font;
@property (nonatomic) IKSegmentedControlStyle style;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic, readonly) NSUInteger numberOfSegments;
@property (nonatomic, readonly) NSArray *segments;

- (id)initWithItems:(NSArray *)items;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment; // 0.0 width indicates that IKSegmentedControl should calc width itself. Otherwise width will be used
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment; // contentView of IKSegment must respond to 'setTitle:' selector
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment; // contentView of IKSegment must respond to 'title' selector

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment; // contentView of IKSegment must respond to 'setImage:' selector
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment; // contentView of IKSegment must respond to 'image' selector

// Supports only UIControlStateNormal and UIControlStateSelected
- (void)setColorForStateNormal:(UIColor *)normalColor forStateSelected:(UIColor *)selectedColor;
//- (void)setImageForStateNormal:(UIImage *)normalImage forStateSelected:(UIImage *)selectedImage;

@end
