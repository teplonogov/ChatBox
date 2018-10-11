//
//  ThemesViewController.m
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* closeButtonImage = [UIImage imageNamed:@"CloseButton"];
    
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithImage:closeButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)];
    
    self.navigationController.navigationBar.topItem.rightBarButtonItem = closeButton;
    
}

- (void)closeAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
