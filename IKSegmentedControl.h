//
//  IKSegmentedControl.h
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.


/*
 @discussion Default cornerRadius is 10.0f
 */
@interface IKSegmentedControl : UIControl {
    NSInteger selectedSegmentIndex;
    NSMutableArray *segments;
    UIColor *separatorColor;
@private
    id _backgrounds[2];
}

@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic, readonly) NSArray *segments;
@property (nonatomic, retain) UIColor *separatorColor;

- (id)initWithItems:(NSArray *)items;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment; // 0.0 width indicates that IKSegmentedControl should calc width itself. Otherwise width will be used
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

// Supports only UIControlStateNormal and UIControlStateSelected
- (void)setColorForNormalState:(UIColor *)normalColor forSelectedState:(UIColor *)selectedColor;
- (UIColor *)normalStateColor;
- (UIColor *)selectedStateColor;

@end
