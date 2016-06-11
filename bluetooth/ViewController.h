#import <UIKit/UIKit.h>

#import "RegisterViewController.h"
#import "LoginViewController.h"

@protocol LoginDelegate;

@interface ViewController : UIViewController <LoginDelegate>
{
    UINavigationController *navController;
    NSString *username;
    bool loggedIn;
}

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonPressed:(id)sender;
- (void)showConfigSelectView:(NSNotification *) notif;

@end

