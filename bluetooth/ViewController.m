#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize welcomeLabel, logoutButton;

NSString *const ABOUT_SEGUE = @"aboutSegue";
NSString *const SELECT_SEGUE = @"configSelectSegue";
NSString *const BUILDER_SEGUE = @"toCIB";
NSString *const SELECT_NOTIF = @"showSelect";
NSString *const KEYCHAIN_SERVICE = @"Anvil";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self displayBluetoothGIF];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    navController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    
    welcomeLabel.numberOfLines = 0;
    welcomeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSArray *accounts = [SSKeychain accountsForService:KEYCHAIN_SERVICE];
    if ([accounts count] > 0) {
        NSDictionary *credentials = accounts[0];
        username = [credentials objectForKey:kSSKeychainAccountKey];
        if (username) {
            welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", username];
        } else {
            welcomeLabel.hidden = YES;
        }
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

- (IBAction)logoutButtonPressed:(id)sender {
    [SSKeychain deletePasswordForService:KEYCHAIN_SERVICE account:username];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
