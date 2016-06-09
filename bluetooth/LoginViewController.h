//
//  LoginViewController.h
//  bluetooth
//
//  Created by Jono Muller on 08/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libpq/libpq-fe.h>
#import <QuartzCore/QuartzCore.h>
#import "RegisterViewController.h"

@protocol LoginDelegate <NSObject>

- (void)passBackData:(NSString *)user loggedIn:(bool)userLoggedIn;

@end

@interface LoginViewController : UIViewController
{
    NSArray *errorMessages;
}

@property (strong, nonatomic) IBOutlet UITextField *userField, *passField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, assign) id<LoginDelegate> delegate;

- (IBAction)loginButtonPressed:(id)sender;

- (void)displayError:(int)error;
- (void)connectToDatabase;

@end
