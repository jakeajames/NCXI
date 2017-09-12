#import <UIKit/_UIBackdropView+Private.h>
#import <UIKit/_UIBackdropViewSettings+Private.h>

@interface NCXIBlurView : UIView
@property (nonatomic, retain) _UIBackdropViewSettings *backdropSettings;
@property (nonatomic, retain) _UIBackdropView *backdropView;
- (void)setProgress:(CGFloat)progress;
@end
