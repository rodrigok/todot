//
//  TDTPasswordViewController.m
//  todot
//
//  Created by Rodrigo K on 2/25/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import "TDTPasswordViewController.h"
#import "UICKeyChainStore.h"

#define MAX_LENGTH 4

@interface TDTPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation TDTPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.saveButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

- (IBAction)saveButtonTouchUpInside:(UIButton *)sender
{
    [UICKeyChainStore setString:self.textField.text forKey:@"password"];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender
{
    self.saveButton.enabled = [sender.text length] == 4;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
