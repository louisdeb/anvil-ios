#import <UIKit/UIKit.h>

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface ViewController : UIViewController
{
    UINavigationController *navController;
    NSString *username;
}

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)selectButtonPressed:(id)sender;

@end

