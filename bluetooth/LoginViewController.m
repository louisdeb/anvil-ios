//
//  LoginViewController.m
//  bluetooth
//
//  Created by Jono Muller on 08/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userField, passField, loginButton, errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    errorMessages = [NSArray arrayWithObjects:@"Please enter a value in both fields.", @"Invalid login credentials, please try again.", @"Could not connect to database, please try again later.", nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    errorLabel.hidden = YES;
    errorLabel.layer.cornerRadius = 8;
    errorLabel.layer.masksToBounds = YES;
    errorLabel.numberOfLines = 0;
    errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    CALayer *userBorder = [CALayer layer];
    CGFloat borderWidth = 1;
    userBorder.borderColor = [UIColor whiteColor].CGColor;
    userBorder.frame = CGRectMake(0, userField.frame.size.height - borderWidth, userField.frame.size.width, userField.frame.size.height);
    userBorder.borderWidth = borderWidth;
    [userField.layer addSublayer:userBorder];
    userField.layer.masksToBounds = YES;
    
    CALayer *passBorder = [CALayer layer];
    passBorder.borderColor = userBorder.borderColor;
    passBorder.frame = userBorder.frame;
    passBorder.borderWidth = userBorder.borderWidth;
    [passField.layer addSublayer:passBorder];
    passField.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self loginButtonPressed:self];
    [textField resignFirstResponder];
    return NO;
}

- (void)loginButtonPressed:(id)sender {
    if ([userField.text isEqualToString:@""] || [passField.text isEqualToString:@""]) {
        [self displayError:0];
    } else {
        [self connectToDatabase];
    }
}

- (void)displayError:(int)error {
    errorLabel.hidden = NO;
    errorLabel.text = [errorMessages objectAtIndex:error];
}

- (void)connectToDatabase {
    const char *conninfo = "host=db.doc.ic.ac.uk port=5432 dbname=g1527117_u user=g1527117_u password=pcauqNdppz";
    PGconn *conn = PQconnectdb(conninfo);
    
    if (PQstatus(conn) != CONNECTION_OK) {
        [self displayError:2];
    }
    
    NSLog(@"Connection successful");
    
    NSString *username = userField.text;
    NSString *password = passField.text;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_info WHERE username='%@' and password='%@'", username, password];
    const char *constSQL = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, constSQL);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        [self displayError:2];
    }
    
    int numRows = PQntuples(result);
    if (numRows == 1) {
        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self displayError:1];
    }
}

@end
