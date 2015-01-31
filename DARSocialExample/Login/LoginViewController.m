//
//  LoginViewController.m
//  DARSocialExample
//
//  Created by Alessio Roberto on 25/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

#import "LoginViewController.h"
#import "UserMapViewController.h"

#import "DARDBManager+Bolts.h"

#import <MBProgressHUD.h>

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = NSLocalizedString(@"Login Email Label", nil);
    _passwordLabel.text = NSLocalizedString(@"Login Password Label", nil);
    
    _mailTextField.placeholder = NSLocalizedString(@"Login Email TextField", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"Login Password TextField", nil);
    
    [self.loginButton setTitle:NSLocalizedString(@"Login Login Button", nil) forState:UIControlStateNormal];
    [self.signupButton setTitle:NSLocalizedString(@"Login Signup Button", nil) forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mailTextField.text = @"mail@alessioroberto.it";
    [self login:self];
}

#pragma mark - Private methods
/*
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
*/
#pragma mark Actions
- (IBAction)login:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *query = [NSString stringWithFormat:@"select * from users where email like '%@'", self.mailTextField.text];
    
    __weak __typeof(self)weakSelf = self;
    
    [[[DARDBManager sharedInstance] makeQuery:query] continueWithSuccessBlock:^id(BFTask *task) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSArray *result = (NSArray *)task.result;
        
        BOOL successful = (result.count == 1) ? YES : NO;
        if (successful) {
            // Login successful
            [[NSUserDefaults standardUserDefaults] setObject:[result firstObject] forKey:@"com.alessioroberto.userLogged"];
            [strongSelf performSegueWithIdentifier:@"toHomeFromLoginSegue" sender:strongSelf];
        }
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        dispatch_async(queue,^{
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            
            if (!successful) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil)
                                                                message:NSLocalizedString(@"Wrong Email", nil)
                                                               delegate:strongSelf
                                                      cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            }
        });
        
        return nil;
    }];
}

- (IBAction)signup:(id)sender {
}

#pragma mark UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mailTextField && self.mailTextField.text.length > 0) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField && self.passwordTextField.text.length > 0) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
