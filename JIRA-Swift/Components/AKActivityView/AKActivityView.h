
#import <UIKit/UIKit.h>

#define kActivityBgColor [UIColor whiteColor]
#define kActivityIndicatorColor RGBAColor(180, 180, 180, 1)

static BOOL const showCircleIndicator = YES;

@interface AKActivityView : UIView

+ (AKActivityView *)addToView:(UIView *)view;
+ (void)removeAnimated:(BOOL)animated;

@end

@interface CircleIndicatorView : UIView

@end

@interface UIApplication (KeyboardView)

- (UIView *)keyboardView;



@end
