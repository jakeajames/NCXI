#import "NCXIBlurView.h"
#import "NCXISearchWidgetsPageViewController.h"

@interface SBLockScreenDateViewController : UIViewController

@end

@interface NCXIViewController : UIViewController <UIScrollViewDelegate>
@property(retain, nonatomic) UIImageView *wallpaperView;
@property(retain, nonatomic) NCXIBlurView *blurView;
@property(retain, nonatomic) SBLockScreenDateViewController *dateView;
@property(retain, nonatomic) NCXISearchWidgetsPageViewController *widgetsViewController;
@property(retain, nonatomic) UIView *widgetsPage;
@property(retain, nonatomic) UIView *notificationsPage;
@property(retain, nonatomic) UIView *notificationsExpandedSuperview;
@property(retain, nonatomic) UIScrollView *contentScrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
+(NCXIViewController *)sharedInstance;
-(void)setProgress:(CGFloat)progress;
-(void)adjustVerticalDateOffset:(CGPoint)point;
-(void)adjustWidgetsForLongLook:(BOOL)active;
@end
