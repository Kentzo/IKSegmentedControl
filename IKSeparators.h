
@class IKSegmentedControl;

@interface IKSeparators : UIView {
}

@property (nonatomic, readonly) IKSegmentedControl *segmentedControl;
/**
 @default [UIColor lightGrayColor]
 @discussion UIColor and UIImage are supported.
 */
@property (nonatomic, retain) id separator;

- (id)initWithSegmentedControl:(IKSegmentedControl *)aSegmentedControl;

@end
