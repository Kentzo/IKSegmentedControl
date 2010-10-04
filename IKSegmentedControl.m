//
//  IKSegmentedControl.m
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.

#import "IKSegmentedControl.h"
#import "IKSegment.h"


@interface IKSegmentedControl (/* Private Stuff Here */)

- (void)_updateSegments;

@end


static const NSUInteger _NormalState = 0;
static const NSUInteger _SelectedState = 1;

@implementation IKSegmentedControl
@synthesize selectedSegmentIndex;
@synthesize segments;
@synthesize separatorColor;

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    BOOL automatic = NO;
    
    if (![key isEqualToString:@"selectedSegmentIndex"]) {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}


- (void)setSelectedSegmentIndex:(NSInteger)newSelectedSegmentIndex {
    if (newSelectedSegmentIndex != selectedSegmentIndex) {
        [self willChangeValueForKey:@"selectedSegmentIndex"];
        selectedSegmentIndex = newSelectedSegmentIndex;
        [self _updateSegments];
        [self didChangeValueForKey:@"selectedSegmentIndex"];
    }
}


- (void)setSeparatorColor:(UIColor *)newSeparatorColor {
    [newSeparatorColor retain];
    [separatorColor release];
    separatorColor = newSeparatorColor;
    [self _updateSegments];
}


- (id)initWithItems:(NSArray *)items {
    NSParameterAssert([items count]);
    
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0f;
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
    [segments release];
    [separatorColor release];
    [_backgrounds[_NormalState] release];
    [_backgrounds[_SelectedState] release];
    [super dealloc];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    NSArray *customWidths = [[segments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"width != 0.0"]] valueForKey:@"width"];
    CGFloat maxSegmentWidth = boundsSize.width;
    for (NSNumber *width in customWidths) {
        maxSegmentWidth -= [width floatValue];
    }
    maxSegmentWidth /= [segments count] - [customWidths count];
    maxSegmentWidth = floor(maxSegmentWidth);
    
    // Calculate segments widths
    CGFloat totalWidth = 0.0f;
    for (IKSegment *segment in segments) {
        CGRect frame = CGRectZero;
        if (segment.width == 0.0f) {
            frame.size.width = maxSegmentWidth;
        }
        else {
            frame.size.width = segment.width;
        }
        totalWidth += frame.size.width;
        segment.frame = frame;
    }
    
    // Calculate frames
    CGFloat addWidth = boundsSize.width - totalWidth;
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
            segment.backgroundColor = _backgrounds[_SelectedState];
        }
        else {
            segment.backgroundColor = _backgrounds[_NormalState];
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
            [self _updateSegments];
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


- (void)setColorForNormalState:(UIColor *)normalColor forSelectedState:(UIColor *)selectedColor {
    [_backgrounds[_NormalState] release];
    _backgrounds[_NormalState] = [normalColor retain];
    [_backgrounds[_SelectedState] release];
    _backgrounds[_SelectedState] = [selectedColor retain];
}


- (UIColor *)normalStateColor {
    return _backgrounds[_NormalState];
}


- (UIColor *)selectedStateColor {
    return _backgrounds[_SelectedState];
}


//- (void)setImageForStateNormal:(UIImage *)normalImage forStateSelected:(UIImage *)selectedImage {
//    [_background[_NormalState] release];
//    _background[_NormalState] = [normalImage retain];
//    [_background[_SelectedState] release];
//    _background[_SelectedState] = [selectedImage retain];
//}


- (void)_updateSegments {
    NSUInteger index = 0;
    for (IKSegment *segment in segments) {
        if (index == selectedSegmentIndex) {
            segment.backgroundColor = _backgrounds[_SelectedState];
        }
        else {
            segment.backgroundColor = _backgrounds[_NormalState];
        }
        ++index;
    }
}

@end
