#import "NCXIBlurView.h"

@interface SBLockScreenDateViewController : UIViewController
@end

@interface NCXIViewController : UIViewController <UIScrollViewDelegate>
@property(retain, nonatomic) UIImageView *wallpaperView;
@property(retain, nonatomic) NCXIBlurView *blurView;
@property(retain, nonatomic) SBLockScreenDateViewController *dateView;
@property(retain, nonatomic) UIView *widgetsPage;
@property(retain, nonatomic) UIView *notificationsPage;
@property(retain, nonatomic) UIScrollView *contentScrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
-(void)setProgress:(CGFloat)progress;
@end
