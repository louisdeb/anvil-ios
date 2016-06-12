//
//  RegisterViewController.m
//  bluetooth
//
//  Created by Jono Muller on 08/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userField, passField, confirmField, emailField, nameField, registerButton, errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    errorMessages = [NSArray arrayWithObjects:@"Please enter a value in all fields.", @"A user with that username already exists, please try again.", @"A user with that email already exists, please try again.", @"Please make sure both passwords are the same.", @"Could not connect to database, please try again later.", nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    errorLabel.hidden = YES;
    errorLabel.layer.cornerRadius = 8;
    errorLabel.layer.masksToBounds = YES;
    errorLabel.numberOfLines = 0;
    errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    fields = @[userField, passField, confirmField, emailField, nameField];
  
    userField.delegate = self;
    passField.delegate = self;
    confirmField.delegate = self;
    emailField.delegate = self;
    nameField.delegate = self;
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
    
    CALayer *confirmBorder = [CALayer layer];
    confirmBorder.borderColor = userBorder.borderColor;
    confirmBorder.frame = userBorder.frame;
    confirmBorder.borderWidth = userBorder.borderWidth;
    [confirmField.layer addSublayer:confirmBorder];
    confirmField.layer.masksToBounds = YES;
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.borderColor = userBorder.borderColor;
    emailBorder.frame = userBorder.frame;
    emailBorder.borderWidth = userBorder.borderWidth;
    [emailField.layer addSublayer:emailBorder];
    emailField.layer.masksToBounds = YES;
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.borderColor = userBorder.borderColor;
    nameBorder.frame = userBorder.frame;
    nameBorder.borderWidth = userBorder.borderWidth;
    [nameField.layer addSublayer:nameBorder];
    nameField.layer.masksToBounds = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerButtonPressed:(id)sender {
    bool emptyField = false;
    
    for (UITextField *field in fields) {
        if ([field.text isEqualToString:@""]) {
            emptyField = true;
        }
    }
    
    if (emptyField) {
        [self displayError:0];
    } else if (![passField.text isEqualToString:confirmField.text]) {
        [self displayError:3];
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
        [self displayError:4];
    }
    
    NSLog(@"Connection successful");
    
    bool userFree = true;
    NSString *username = userField.text;
    NSString *password = passField.text;
    NSString *email = emailField.text;
    NSString *fullname = nameField.text;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_info WHERE username='%@'", username];
    const char *constSQL = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, constSQL);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        [self displayError:4];
    }
    
    int numRows = PQntuples(result);
    if (numRows == 1) {
        userFree = false;
        [self displayError:1];
    }
    
    sql = [NSString stringWithFormat:@"SELECT * FROM user_info WHERE email='%@'", email];
    constSQL = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    result = PQexec(conn, constSQL);
    numRows = PQntuples(result);
    
    if (numRows == 1) {
        userFree = false;
        [self displayError:2];
    }
    
    if (userFree) {
        sql = [NSString stringWithFormat:@"INSERT INTO user_info(username, password, email, fullname) VALUES ('%@', '%@', '%@', '%@')", username, password, email, fullname];
        constSQL = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        result = PQexec(conn, constSQL);
        numRows = PQntuples(result);
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
