#import "IKSeparators.h"
#import "IKSegment.h"
#import "IKSegmentedControl.h"


@implementation IKSeparators
@synthesize segmentedControl;
@synthesize separator;
@synthesize separateSelectedItem;

- (void)setSeparator:(id)newSeparator {
    [newSeparator retain];
    [separator release];
    separator = newSeparator;
    [self setNeedsDisplay];
}


- (id)initWithSegmentedControl:(IKSegmentedControl *)aSegmentedControl {
    if ((self = [super initWithFrame:aSegmentedControl.bounds])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        separator = [[UIColor lightGrayColor] retain];
        segmentedControl = aSegmentedControl;
    }
    return self;
}


- (void)dealloc {
    [separator release];
    [super dealloc];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, FALSE);
    for (int i=1, end=[segmentedControl.segments count]-1; i<end; ++i) {
        if (i == segmentedControl.selectedSegmentIndex && !separateSelectedItem) {
            continue;
        }
        CGRect segmentFrame = [[segmentedControl.segments objectAtIndex:i] frame];
        if ([separator isKindOfClass:[UIColor class]]) {
            [separator setStroke];
            CGContextSetLineWidth(context, 1.0f);
            if (i != segmentedControl.selectedSegmentIndex + 1 || separateSelectedItem) {
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, CGRectGetMinX(segmentFrame), CGRectGetMinY(segmentFrame));
                CGContextAddLineToPoint(context, CGRectGetMinX(segmentFrame), CGRectGetMaxY(segmentFrame));
                CGContextStrokePath(context);
            }
            if (i != segmentedControl.selectedSegmentIndex - 1 || separateSelectedItem) {
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, CGRectGetMaxX(segmentFrame), CGRectGetMinY(segmentFrame));
                CGContextAddLineToPoint(context, CGRectGetMaxX(segmentFrame), CGRectGetMaxY(segmentFrame));
                CGContextStrokePath(context);
            }
        }
        else {
            if (i != segmentedControl.selectedSegmentIndex + 1 || separateSelectedItem) {
                CGRect rect = CGRectMake(CGRectGetMinX(segmentFrame) - [separator size].width/2, CGRectGetMinY(segmentFrame), 
                                         [separator size].width, CGRectGetHeight(segmentFrame));
                [separator drawInRect:rect];
            }
            if (i != segmentedControl.selectedSegmentIndex - 1 || separateSelectedItem) {
                CGRect rect = CGRectMake(CGRectGetMaxX(segmentFrame) - [separator size].width/2, CGRectGetMinY(segmentFrame),
                                         [separator size].width, CGRectGetHeight(segmentFrame));
                [separator drawInRect:rect];
            }
        }
    }
}

@end
