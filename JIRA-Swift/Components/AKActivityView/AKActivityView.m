
#import "AKActivityView.h"

@interface AKActivityView ()

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AKActivityView

static AKActivityView *activityView = nil;

+ (AKActivityView *)addToView:(UIView *)view
{
    if (activityView) {
        [self remove];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (!view) {
        UIViewController *vc = [AKActivityView getTopVC];
        view = vc.view;
    }

    activityView = [[self alloc] initForView:view];
    return activityView;
}

- (AKActivityView *)initForView:(UIView *)view
{
    if (!(self = [super initWithFrame:CGRectZero])) return nil;
    
    self.originalView = view;
    view = [self viewForView:view];
    
    // setup background
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = kActivityBgColor;
    
    // makeBorderView
    self.borderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.borderView.opaque = NO;
    self.borderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if (showCircleIndicator)
    {
        // add custom indicator
        CircleIndicatorView *ind = [[CircleIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self.borderView addSubview:ind];
        ind.center = self.borderView.center;
    }
    else
    {
        // add activity indicator
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.color = [UIColor darkGrayColor];
        [self.activityIndicator startAnimating];
        [self.borderView addSubview:self.activityIndicator];
        self.activityIndicator.center = self.borderView.center;
    }
    
    [view addSubview:self];
    [self addSubview:self.borderView];
    self.borderView.center = self.center;
    
    return self;
}

- (UIView *)viewForView:(UIView *)view
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (keyboardView) {
        view = keyboardView.superview;
    }
    return view;
}

+ (void)removeAnimated:(BOOL)animated
{
    if (!activityView) return;
    
    if (animated) {
        [activityView animateRemove];
    } else {
        [self.class remove];
    }
}

+ (void)remove
{
    if (!activityView) return;
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    [activityView removeFromSuperview];
    activityView = nil;
}

- (void)animateRemove
{
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    self.borderView.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    
    self.borderView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)layoutSubviews
{
    if (!CGAffineTransformIsIdentity(self.borderView.transform)) return;
    
    CGRect frame = self.superview.bounds;
    if (self.superview != self.originalView) {
        frame = [self.originalView convertRect:self.originalView.bounds toView:self.superview];
    }
    self.frame = frame;
}

+ (UIViewController *)getTopVC
{
    UIViewController *alertVC = nil;
    id rootViewController =[UIApplication sharedApplication].delegate.window.rootViewController;
    BOOL done = NO;
    while (!done) {
        if([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbar = (UITabBarController*)rootViewController;
            if (tabbar.selectedIndex < tabbar.viewControllers.count) {
                rootViewController = tabbar.viewControllers[tabbar.selectedIndex];
            }
        } else if([rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController =[((UINavigationController *)rootViewController).viewControllers lastObject];
        } else if ([rootViewController presentedViewController]){
            rootViewController = [rootViewController presentedViewController];
        } else {
            done = YES;
        }
    }
    alertVC = (UIViewController*)rootViewController;
    return alertVC;
}

@end

@implementation CircleIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    [self spinLayer:self.layer duration:1 direction:1];

}

- (void)drawRect:(CGRect)rect
{
    
    CGRect bounds = self.bounds;

    CGFloat lineWidth = 2.0;
    CGFloat radius = bounds.size.width / 2 - lineWidth;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, lineWidth);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    
    CGContextAddArc(ctx, center.x, center.y, radius, 0.0, M_PI * 2 + 0.4, YES);
    CGContextStrokePath(ctx);
}

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration direction:(NSInteger)direction
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];
    rotationAnimation.duration = inDuration;
    rotationAnimation.repeatCount = 100000;
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



@end

@implementation UIApplication (KeyboardView)

- (UIView *)keyboardView
{
    NSArray *windows = [self windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])
    {
        for (UIView *view in [window subviews])
        {
            if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
            {
                return view;
            }
        }
    }
    return nil;
}

@end
