#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize welcomeLabel, loginButton;

NSString *const ABOUT_SEGUE = @"aboutSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    navController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    LoginViewController *loginViewController = [navController.viewControllers objectAtIndex:0];
    loginViewController.delegate = self;
    
    [self displayBluetoothGIF];
    
    welcomeLabel.numberOfLines = 0;
    welcomeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    welcomeLabel.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRegister:)
                                                 name:@"register"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"username: %@", username);
    if (loggedIn) {
        welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", username];
        welcomeLabel.hidden = NO;
        [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        welcomeLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
  [self performSegueWithIdentifier: ABOUT_SEGUE sender: sender];
}

- (IBAction)builderButtonUp:(UIButton *) sender {
    //  [UIView beginAnimations:nil context:NULL];
    //  [UIView setAnimationDelay:0.1];
    //  [UIView setAnimationDuration:0.5];
    //  [UIView commitAnimations];
    [self performSegueWithIdentifier: @"toCIB" sender: sender];
}

- (void)passBackData:(NSString *)user loggedIn:(bool)userLoggedIn {
    username = user;
    loggedIn = userLoggedIn;
}

- (void)handleRegister:(NSNotification *)notification {
    NSDictionary *data = [notification userInfo];
    username = [data objectForKey:@"username"];
    loggedIn = [data objectForKey:@"loggedIn"];
}

- (IBAction)loginButtonPressed:(id)sender {
    if (loggedIn) {
        // log out...
    } else {
        [self presentViewController:navController animated:YES completion:nil];
    }
}
@end
