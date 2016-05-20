#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self displayWifiGIF];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)displayWifiGIF {
  CGFloat height = 200;
  CGFloat width = 200;
  CGFloat posX = (self.view.frame.size.width / 2) - (width / 2);
  CGFloat posY = (self.view.frame.size.height / 2) - (height / 2);
  CGFloat speed = 1.5;
  
  UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
  animatedImageView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"wifi0.png"],
                                       [UIImage imageNamed:@"wifi1.png"],
                                       [UIImage imageNamed:@"wifi2.png"],
                                       [UIImage imageNamed:@"wifi3.png"], nil];
  animatedImageView.animationDuration = speed;
  animatedImageView.animationRepeatCount = 0;
  [animatedImageView startAnimating];
  [self.view addSubview: animatedImageView];
}

@end
