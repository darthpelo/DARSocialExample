//
//  UserProfileViewController.m
//  DARSocialExample
//
//  Created by Alessio Roberto on 30/01/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *relationTextField;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;

@property (nonatomic, strong) NSDictionary *userLogged;

@property (nonatomic, assign) BOOL profileEditable;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = NSLocalizedString(@"Name", nil);
    _emailLabel.text = NSLocalizedString(@"Email", nil);
    _phoneNumberLabel.text = NSLocalizedString(@"Phone", nil);
    _addressLabel.text = NSLocalizedString(@"Address", nil);
    _relationLabel.text = NSLocalizedString(@"Relation", nil);
    
    _profileEditable = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(editUserProfile)
                                              ];
    self.navigationItem.title = @"Profile";
    
    _userLogged = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.alessioroberto.userLogged"];
    
    _userNameTextField.text = [NSString stringWithFormat:@"%@ %@", self.userLogged[@"name"], self.userLogged[@"lastName"]];
    _emailTextField.text = self.userLogged[@"email"];
    _phoneNumberTextField.text = self.userLogged[@"phoneNumber"];
    _addressTextField.text = self.userLogged[@"address"];
    
    switch ([self.userLogged[@"relation"] intValue]) {
        case 0:
            _relationTextField.text = @"Singled";
            break;
            
        case 1:
            _relationTextField.text = @"Married";
            break;
            
        case 2:
            _relationTextField.text = @"Diverce";
            break;
        
        case 3:
            _relationTextField.text = @"Widow";
            break;
    }
}

#pragma mark - Private methods

- (void)editUserProfile
{
    if (self.profileEditable) {
        self.profileEditable = NO;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(editUserProfile)
                                                  ];
        
        _userNameTextField.enabled = NO;
        _emailTextField.enabled = NO;
        _phoneNumberTextField.enabled = NO;
        _addressTextField.enabled = NO;
        _relationLabel.enabled = NO;
        
    } else {
        self.profileEditable = YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(editUserProfile)
                                                  ];
        
        _userNameTextField.enabled = YES;
        _emailTextField.enabled = YES;
        _phoneNumberTextField.enabled = YES;
        _addressTextField.enabled = YES;
        _relationTextField.enabled = YES;
    }
}

@end
