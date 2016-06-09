#import "ConfigurationSelectViewController.h"

@implementation ConfigurationSelectViewController

int const PAN_TRANSLATION_MIN = 200;
NSString *const CONTROLLER_SEGUE = @"controllerSegue";

-(void)viewDidLoad {
  [super viewDidLoad];
}

-(IBAction)selectView:(id)sender {
  [self performSegueWithIdentifier:CONTROLLER_SEGUE sender:sender];
}

-(IBAction)handlePan:(UIPanGestureRecognizer*) sender {
  CGPoint translation = [sender translationInView: self.view];
  
  if (fabs(translation.y) > PAN_TRANSLATION_MIN)
    [self dismissViewControllerAnimated:true completion:nil];
}


@end