#import "NCXIViewController.h"
#import "NCXISearchWidgetsPageViewController.h"

%subclass NCXISearchWidgetsPageViewController : SBDashBoardTodayViewController
- (id)init {
	self = %orig;
  self.view.autoresizingMask = 18;
	return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	%orig;

	[[NCXIViewController sharedInstance] adjustVerticalDateOffset:[self _offsetForScrollView:scrollView]];
}
%end
