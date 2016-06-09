#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface ViewController : UIViewController <LoginDelegate>
{
    LoginViewController *loginViewController;
    NSString *username;
    bool loggedIn;
}

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonPressed:(id)sender;

@end

