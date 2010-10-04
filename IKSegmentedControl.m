//
//  IKSegmentedControl.m
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.

#import "IKSegmentedControl.h"
#import "IKSegment.h"


static const NSUInteger _NormalState = 0;
static const NSUInteger _SelectedState = 1;

@implementation IKSegmentedControl
@synthesize font;
@synthesize style;
@synthesize selectedSegmentIndex;
@synthesize numberOfSegments;
@synthesize segments;

- (id)initWithItems:(NSArray *)items {
    if (![items count]) {
        [self dealloc];
        return nil;
    }
    if (self = [super initWithFrame:CGRectZero]) {
        self.font = [UIFont systemFontOfSize:14.0f];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0f;
        numberOfSegments = [items count];
        segments = [[NSMutableArray alloc] initWithCapacity:[items count]];
        for (id item in items) {
            IKSegment *segment = nil;
            if ([item isKindOfClass:[UIView class]]) {
                segment = [[IKSegment alloc] initWithFrame:CGRectZero];
                segment.contentView = item;
            }
            else if ([item isKindOfClass:[NSString class]]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.textAlignment = UITextAlignmentCenter;
                label.text = item;
                segment = [[IKSegment alloc] initWithFrame:CGRectZero];
                segment.contentView = label;
                [label release];
            }
            else if ([item isKindOfClass:[UIImage class]]) {
                // TODO: add support for images
                [self dealloc];
                return nil;                
            }
            else {
                NSAssert(NO, @"You can use only NSString, UIImage or UIView instances as items, but you use %@", NSStringFromClass([item class]));
                __builtin_unreachable();
            }
            [segments addObject:segment];
            [self addSubview:segment];
            [segment release];
        }
    }
    return self;
}


- (void)dealloc {
    [font release];
    [segments release];
    [super dealloc];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGFloat maxSegmentWidth = boundsSize.width/[segments count];
    
    // Calculate segments widths
    CGFloat totalWidth = 0.0f;
    for (IKSegment *segment in segments) {
        [segment sizeToFit];
        CGRect frame = segment.frame;
        frame.size.width = MIN(maxSegmentWidth, frame.size.width);
        totalWidth += frame.size.width;
        segment.frame = frame;
    }
    
    NSUInteger autoWidthsCount = [[segments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"width == 0.0"]] count];
    CGFloat addWidth = floor((boundsSize.width - totalWidth)/autoWidthsCount);
    CGPoint origin = CGPointZero;
    NSUInteger index = 0;
    for (IKSegment *segment in segments) {
        CGRect frame = segment.frame;
        if (segment.width == 0.0f) {
            frame.size.width += addWidth;
        }
        frame.size.height = boundsSize.height;
        frame.origin = origin;
        origin.x += frame.size.width;
        segment.frame = frame;
        if (index == selectedSegmentIndex) {
            segment.backgroundColor = _background[_SelectedState];
        }
        else {
            segment.backgroundColor = _background[_NormalState];
        }
        ++index;
    }
}


- (void)drawRect:(CGRect)rect {

}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL result = [super beginTrackingWithTouch:touch withEvent:event];
    if ([event type] == UIEventTypeTouches && [segments count]) {
        CGPoint point = [touch locationInView:self];
        NSUInteger index = 0;
        for (IKSegment *segment in segments) {
            if (CGRectContainsPoint(segment.frame, point))
                break;
            ++index;
        }
        NSAssert(index < [segments count], @"IKSegmentedControl must have IKSegment for each point inside it");
        if (index != selectedSegmentIndex) {
            selectedSegmentIndex = index;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self setNeedsLayout];
        }
        return YES;
    }
    else {
        return result;
    }
}


- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment {
    [[segments objectAtIndex:segment] setWidth:width];
}


- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment {
    return [[segments objectAtIndex:segment] width];
}


- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    id view = [[segments objectAtIndex:segment] contentView];
    [view setTitle:title];
}


- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
    id view = [[segments objectAtIndex:segment] contentView];
    return [view title];
}


- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    id view = [[segments objectAtIndex:segment] contentView];
    [view setImage:image];
}


- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment {
    id view = [[segments objectAtIndex:segment] contentView];
    return [view image];
}


- (void)setColorForStateNormal:(UIColor *)normalColor forStateSelected:(UIColor *)selectedColor {
    [_background[_NormalState] release];
    _background[_NormalState] = [normalColor retain];
    [_background[_SelectedState] release];
    _background[_SelectedState] = [selectedColor retain];
}


//- (void)setImageForStateNormal:(UIImage *)normalImage forStateSelected:(UIImage *)selectedImage {
//    [_background[_NormalState] release];
//    _background[_NormalState] = [normalImage retain];
//    [_background[_SelectedState] release];
//    _background[_SelectedState] = [selectedImage retain];
//}

@end
