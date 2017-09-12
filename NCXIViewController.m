#import "NCXIViewController.h"

#import <objc/runtime.h>

@interface SBFWallpaperView : UIView
@property (nonatomic,retain) UIImage * wallpaperImage;              //@synthesize displayedImage=_displayedImage - In the implementation block
@end

@interface SBWallpaperController : UIViewController
+(id)sharedInstance;
-(id)_wallpaperViewForVariant:(long long)arg1 ;
@property (nonatomic,retain) SBFWallpaperView * lockscreenWallpaperView;                                             //@synthesize lockscreenWallpaperView=_lockscreenWallpaperView - In the implementation block
-(SBFWallpaperView *)lockscreenWallpaperView;
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
@property (setter=_setDisplayedImage:,getter=_displayedImage,nonatomic,retain) UIImage * displayedImage;
- (UIImage *)wallpaperImage;
@end

@implementation NCXIViewController
-(id)init {
  self = [super init];

  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.contentScrollView.contentSize = CGSizeMake(screenBounds.size.width * 2, screenBounds.size.height);
  self.contentScrollView.pagingEnabled = TRUE;
  self.contentScrollView.delegate = self;

  self.wallpaperView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.wallpaperView];

  SBFStaticWallpaperView *wallpaperView = [[objc_getClass("SBWallpaperController") sharedInstance] _wallpaperViewForVariant:0];
  self.wallpaperView.image = [wallpaperView.wallpaperImage copy];

  self.blurView = [[NCXIBlurView alloc] init];
  self.blurView.frame = self.view.bounds;
  [self.view addSubview:self.blurView];

  self.dateView = [[NSClassFromString(@"SBLockScreenDateViewController") alloc] init];
  self.dateView.view.frame = CGRectMake(0, screenBounds.size.height/10.5, screenBounds.size.width,screenBounds.size.height/5);
  [self.view addSubview:self.dateView.view];

  self.notificationsPage = [[UIView alloc] init];
  self.notificationsPage.frame = CGRectMake(screenBounds.size.width, 0, screenBounds.size.height, screenBounds.size.width);
  [self.contentScrollView addSubview:self.notificationsPage];

  [self.view addSubview:self.contentScrollView];

  self.pageControl = [[[UIPageControl alloc] init] autorelease];
  self.pageControl.frame = CGRectMake(screenBounds.size.width/2 - screenBounds.size.width/16,screenBounds.size.height - screenBounds.size.height/32,screenBounds.size.width/8,screenBounds.size.height/32);
  self.pageControl.numberOfPages = 2;
  self.pageControl.currentPage = 0;
  [self.view addSubview:self.pageControl];

  return self;
}
-(void)setProgress:(CGFloat)progress {
  self.wallpaperView.alpha = 1 - (progress/2);
  [self.blurView setProgress:progress];
}
-(void)viewDidLayoutSubviews {
  SBFStaticWallpaperView *wallpaperView = [[objc_getClass("SBWallpaperController") sharedInstance] _wallpaperViewForVariant:0];
  self.wallpaperView.image = [wallpaperView.displayedImage copy];
  self.wallpaperView.frame = self.view.bounds;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.contentScrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.contentScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}
@end
