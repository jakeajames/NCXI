#import "NCXISearchWidgetsPageViewController.h"

%subclass NCXISearchWidgetsPageViewController : SBDashBoardTodayViewController
- (id)init {
	self = %orig;
  self.view.autoresizingMask = 18;
	return self;
}
%end
