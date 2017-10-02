#import "NCXIViewController.h"

@interface NCMaterialView : UIView
@end

@interface SBNotificationCenterViewController : UIViewController
@property(retain, nonatomic) NCXIViewController *notificationCenterViewController;
@end

@interface NCNotificationListViewController : UIViewController
@end

@interface SBNotificationCenterWithSearchViewController : UIViewController
@property (nonatomic,readonly) NCNotificationListViewController * notificationListViewController;
@end

@interface UIStatusBar : UIView
@end

%hook SBNotificationCenterViewController
%property (retain, nonatomic) NCXIViewController *notificationCenterViewController;
-(void)viewDidLoad {
  %orig;

  for(UIView *subview in self.view.subviews){
    subview.hidden = TRUE;
  }

}
-(void)viewWillAppear:(BOOL)animated{
  %orig;
  [self.view.subviews lastObject].hidden = YES;
  self.notificationCenterViewController = [[NCXIViewController alloc] init];
  self.notificationCenterViewController.view.frame = self.view.bounds;
  [self.view addSubview:self.notificationCenterViewController.view];
}

-(void)viewDidLayoutSubviews {
  %orig;

  CGRect screenBounds = [[UIScreen mainScreen] bounds];

  SBNotificationCenterWithSearchViewController* _notificationCenterWithSearchViewController = [self valueForKey:@"_notificationCenterWithSearchViewController"];
  _notificationCenterWithSearchViewController.notificationListViewController.view.tag = 1036;
  _notificationCenterWithSearchViewController.notificationListViewController.view.frame = CGRectMake(0,screenBounds.size.height/3, screenBounds.size.width, screenBounds.size.height - screenBounds.size.height/3);
  [self.notificationCenterViewController.notificationsPage addSubview:_notificationCenterWithSearchViewController.notificationListViewController.view];

  [self.notificationCenterViewController.widgetsViewController viewWillAppear:TRUE];
  [self.notificationCenterViewController.widgetsViewController viewDidAppear:TRUE];
  [self.notificationCenterViewController.widgetsViewController willActivateHosting];

  UIStatusBar* _statusBar = [self valueForKey:@"_statusBar"];
  _statusBar.hidden = FALSE;
  [self.notificationCenterViewController.view addSubview:_statusBar];

}
-(void)_setContainerFrame:(CGRect)arg1 {
    %orig;

  	UIView *container = [self valueForKey:@"_containerView"];
  	CGRect containerFrame = [container frame];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    UIView *content = [self valueForKey:@"_contentView"];
  	CGRect contentFrame = [content frame];
  	contentFrame.origin.y = containerFrame.origin.y;
  	[self.notificationCenterViewController.view setFrame:contentFrame];

    [self.notificationCenterViewController setProgress:-containerFrame.origin.y/screenBounds.size.height];
}
%end

// By default the notifications are transparent because the NC has its own blur. We don't have one so we need to adjust.
%hook NCMaterialView
- (id)initWithStyleOptions:(unsigned long long)arg1 {
  if(arg1 == 1){
    return %orig(4);
  }
  return %orig(arg1);
}
%end

// Fixing notifications view location.
%hook UIView
-(void)setFrame:(CGRect)frame{
  if(self.tag == 1036){
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.clipsToBounds = TRUE;
    frame.origin.y = screenBounds.size.height/3.5;
  }
  %orig(frame);
}
%end

// Adjusting the widgets page frame because we have to make sure the long look of notifications appears.
%hook NCLongLookPresentationController
-(void)presentationTransitionWillBegin {
  %orig;
  [[NCXIViewController sharedInstance] adjustWidgetsForLongLook:TRUE];
  [NCXIViewController sharedInstance].contentScrollView.scrollEnabled = FALSE;
}
-(void)dismissalTransitionWillBegin {
  %orig;
  [[NCXIViewController sharedInstance] adjustWidgetsForLongLook:FALSE];
  [NCXIViewController sharedInstance].contentScrollView.scrollEnabled = TRUE;
}
%end
