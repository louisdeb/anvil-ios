#import "AboutViewController.h"

@implementation AboutViewController

int const PAN_TRANSLATION_MIN = 200;

-(void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"AboutViewController loaded");
}

-(IBAction)handlePan:(UIPanGestureRecognizer*) sender {
  NSLog(@"Pan handled");
  CGPoint translation = [sender translationInView: self.view];
  
  if (fabs(translation.y) > PAN_TRANSLATION_MIN)
    [self dismissViewControllerAnimated:true completion:nil];
}

@end