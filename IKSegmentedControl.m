//
//  IKSegmentedControl.m
//  IKSegmentedControl
//
//  Created by Ilya Kulakov on 4.10.10.
//  Copyright 2010. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "IKSegmentedControl.h"
#import "IKSegment.h"
#import "IKSeparators.h"


@interface IKSegmentedControl (/* Private Stuff Here */)

- (void)_updateSegments;

@end


static const NSUInteger _NormalState = 0;
static const NSUInteger _SelectedState = 1;

@implementation IKSegmentedControl
@synthesize selectedSegmentIndex;
@synthesize segments;
@dynamic separator;
@synthesize separateSelectedItem;

static void SetSegmentBackground(IKSegment *segment, id background) {
    if ([background isKindOfClass:[UIColor class]]) {
        segment.backgroundColor = background;
        segment.backgroundImage = nil;
    }
    else {
        segment.backgroundColor = [UIColor clearColor];
        segment.backgroundImage = background;
    }
}


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
        [_separators setNeedsDisplay];
        [self didChangeValueForKey:@"selectedSegmentIndex"];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


- (void)setSeparator:(id)newSeparator {
    _separators.separator = newSeparator;
}


- (id)separator {
    return _separators.separator;
}


- (id)initWithItems:(NSArray *)items {
    NSParameterAssert([items count] > 1);
    
    if ((self = [super initWithFrame:CGRectZero])) {
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
                UIImageView *imageView = [[UIImageView alloc] initWithImage:item];
                segment = [[IKSegment alloc] initWithFrame:imageView.frame];
                segment.contentView = imageView;
                [imageView release];
            }
            else {
                NSAssert(NO, @"You can use only NSString, UIImage or UIView instances as items, but you use %@", NSStringFromClass([item class]));
                __builtin_unreachable();
            }
            [segments addObject:segment];
            [self addSubview:segment];
            [segment release];
        }
        
        _separators = [[IKSeparators alloc] initWithSegmentedControl:self];
        [self addSubview:_separators];
        [_separators release];
    }
    return self;
}


- (void)dealloc {
    [segments release];
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
    maxSegmentWidth = ceil(maxSegmentWidth);
    
    // Calculate segments frames
    CGPoint origin = CGPointZero;
    NSUInteger index = 0;
    for (IKSegment *segment in segments) {
        CGRect frame = segment.frame;
        if (segment.width == 0.0f) {
            frame.size.width = maxSegmentWidth;
        }
        else {
            frame.size.width = segment.width;
        }
        frame.size.height = boundsSize.height;
        frame.origin = origin;
        origin.x += frame.size.width;
        segment.frame = frame;
        if (index == selectedSegmentIndex) {
            SetSegmentBackground(segment, _backgrounds[_SelectedState]);
        }
        else {
            SetSegmentBackground(segment, _backgrounds[_NormalState]);
        }
        ++index;
    }
    [[segments objectAtIndex:0] setSegmentPosition:IKSegmentPositionLeft];
    [[segments lastObject] setSegmentPosition:IKSegmentPositionRight];
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL result = [super beginTrackingWithTouch:touch withEvent:event];
    if ([event type] == UIEventTypeTouches && [segments count]) {
        CGPoint point = [touch locationInView:self];
        NSUInteger index = 0;
        for (IKSegment *segment in segments) {
            if (CGRectContainsPoint(segment.frame, point)) {
                self.selectedSegmentIndex = index;
                break;
            }
            ++index;
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


- (void)setBackgroundForNormalState:(id)normalBackground forSelectedState:(id)selectedBackground {
    NSParameterAssert([normalBackground isKindOfClass:[UIColor class]] || [normalBackground isKindOfClass:[UIImage class]]);
    [_backgrounds[_NormalState] release];
    _backgrounds[_NormalState] = [normalBackground retain];
    
    NSParameterAssert([selectedBackground isKindOfClass:[UIColor class]] || [selectedBackground isKindOfClass:[UIImage class]]);
    [_backgrounds[_SelectedState] release];
    _backgrounds[_SelectedState] = [selectedBackground retain];
    [self _updateSegments];
}


- (id)normalStateBackground {
    return _backgrounds[_NormalState];
}


- (id)selectedStateBackground {
    return _backgrounds[_SelectedState];
}

- (void)_updateSegments {
    NSUInteger index = 0;
    for (IKSegment *segment in segments) {
        if (index == selectedSegmentIndex) {
            SetSegmentBackground(segment, _backgrounds[_SelectedState]);
        }
        else {
            SetSegmentBackground(segment, _backgrounds[_NormalState]);
        }
        ++index;
    }
}

- (void)setSeparateSelectedItem:(BOOL)aSeparateSelectedItem {
    _separators.separateSelectedItem = aSeparateSelectedItem;
}

- (BOOL)separateSelectedItem {
    return _separators.separateSelectedItem;
}

@end
