//
//  ThemesViewController.m
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

#import "ThemesViewController.h"
#import "UIColor+ChatBox.h"

@interface ThemesViewController () 

@property (strong, nonatomic) Themes* themes;

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* closeButtonImage = [UIImage imageNamed:@"CloseButton"];
    
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithImage:closeButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)];
    
    _themeOneButton.layer.cornerRadius = 10;
    _themeTwoButton.layer.cornerRadius = 10;
    _themeThreeButton.layer.cornerRadius = 10;
    
    self.themes = [[Themes alloc] init];
    self.themes.theme1 = [UIColor lightYellowColor];
    self.themes.theme2 = [UIColor coralColor];
    self.themes.theme3 = [UIColor lightGreenColor];
        
    self.navigationController.navigationBar.topItem.leftBarButtonItem = closeButton;
    
}

#pragma mark - Actions

- (void)closeAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)themeOneAction:(UIButton *)sender {
    self.view.backgroundColor = self.themes.theme1;
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme1];
}

- (IBAction)themeTwoAction:(UIButton *)sender {
    self.view.backgroundColor = self.themes.theme2;
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme2];
}

- (IBAction)themeThreeAction:(id)sender {
    self.view.backgroundColor = self.themes.theme3;
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme3];
}


@end




