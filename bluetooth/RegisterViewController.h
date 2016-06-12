//
//  RegisterViewController.h
//  bluetooth
//
//  Created by Jono Muller on 08/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libpq/libpq-fe.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    NSArray *errorMessages, *fields;
}

@property (strong, nonatomic) IBOutlet UITextField *userField, *passField, *confirmField, *emailField, *nameField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)registerButtonPressed:(id)sender;

- (void)displayError:(int)error;
- (void)connectToDatabase;

@end
