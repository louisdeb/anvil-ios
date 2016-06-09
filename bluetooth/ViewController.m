#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSString *const ABOUT_SEGUE = @"aboutSegue";
NSString *const SELECT_SEGUE = @"configSelectSegue";
NSString *const BUILDER_SEGUE = @"toCIB";
NSString *const SELECT_NOTIF = @"showSelect";

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
  [self displayBluetoothGIF];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConfigSelectView:) name:SELECT_NOTIF object:nil];
}

- (void)viewDidUnload {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)displayBluetoothGIF {
  CGFloat height = 200;
  CGFloat width = 200;
  CGFloat posX = (self.view.frame.size.width / 2) - (width / 2);
  CGFloat posY = (self.view.frame.size.height / 2) - (height / 2);
  CGFloat speed = 3.2;
  
  UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
  NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:90];
  
  for (int i = 0; i <= 89; i++) {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bluetooth-logo_%05d.png", i]];
    [tempArray addObject:image];
  }
  
  animatedImageView.animationImages = [NSArray arrayWithArray:tempArray];
  
  animatedImageView.animationDuration = speed;
  animatedImageView.animationRepeatCount = 0;
  [animatedImageView startAnimating];
  animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview: animatedImageView];
}

- (IBAction)aboutButtonUp:(UIButton *) sender {
//  [UIView beginAnimations:nil context:NULL];
//  [UIView setAnimationDelay:0.1];
//  [UIView setAnimationDuration:0.5];
//  [UIView commitAnimations];
  [self performSegueWithIdentifier:ABOUT_SEGUE sender:sender];
}

- (IBAction)builderButtonUp:(UIButton *) sender {
    //  [UIView beginAnimations:nil context:NULL];
    //  [UIView setAnimationDelay:0.1];
    //  [UIView setAnimationDuration:0.5];
    //  [UIView commitAnimations];
    [self performSegueWithIdentifier:BUILDER_SEGUE sender:sender];
}

- (void)showConfigSelectView:(NSNotification *) notif {
  [self performSegueWithIdentifier:SELECT_SEGUE sender:self];
}

@end
