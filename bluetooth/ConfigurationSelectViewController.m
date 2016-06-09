#import "ConfigurationSelectViewController.h"
#import "AppDelegate.h"

@implementation ConfigurationSelectViewController

int const PAN_TRANSLATION_MIN = 200;
NSString *const CONTROLLER_SEGUE = @"controllerSegue";

-(void)viewDidLoad {
  [super viewDidLoad];
}

-(IBAction)selectView:(id)sender {
  /* Add key service. This should be done based on the JSON file. */
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSMutableArray<NSNumber *> *codes = [[NSMutableArray alloc] init];
  NSNumber *num = [NSNumber numberWithInt:10];
  [codes addObject:num];
  [appDelegate addKeyService:codes];
  
  [self performSegueWithIdentifier:CONTROLLER_SEGUE sender:sender];
}

-(IBAction)handlePan:(UIPanGestureRecognizer*) sender {
  CGPoint translation = [sender translationInView: self.view];
  
  if (fabs(translation.y) > PAN_TRANSLATION_MIN)
    [self dismissViewControllerAnimated:true completion:nil];
}


@end