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

%hook SBNotificationCenterViewController
%property (retain, nonatomic) NCXIViewController *notificationCenterViewController;
-(void)viewDidLoad{
  %orig;

  for(UIView *subview in self.view.subviews){
    subview.hidden = TRUE;
  }

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

%hook NCMaterialView

- (id)initWithStyleOptions:(unsigned long long)arg1 {
  if(arg1 == 1){
    return %orig(4);
  }
  return %orig(arg1);
}
%end

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
