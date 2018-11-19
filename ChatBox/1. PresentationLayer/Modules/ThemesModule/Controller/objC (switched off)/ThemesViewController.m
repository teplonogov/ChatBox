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

@property (retain, nonatomic) Themes* themes;

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSData* themeData = [NSUserDefaults.standardUserDefaults objectForKey:@"theme"];
    
    if (themeData != nil) {
        UIColor* themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:themeData];
        self.view.backgroundColor = themeColor;
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:96.0f/255.0f green:154/255.0f blue:234/255.0f alpha:1];
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    UIImage* closeButtonImage = [UIImage imageNamed:@"CloseButton"];
    
    UIBarButtonItem* closeButton = [[[UIBarButtonItem alloc] initWithImage:closeButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)] autorelease];
    
    _themeOneButton.layer.cornerRadius = 10;
    _themeTwoButton.layer.cornerRadius = 10;
    _themeThreeButton.layer.cornerRadius = 10;
    
    self.themes = [[[Themes alloc] init] autorelease];
    self.themes.theme1 = [UIColor whiteColor];
    self.themes.theme2 = [UIColor skyBlueColor];
    self.themes.theme3 = [UIColor nightBlueColor];
        
    self.navigationController.navigationBar.topItem.leftBarButtonItem = closeButton;
    
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)dealloc {
    [self.themes release];
    //self.themes = nil;


    NSLog(@"controller deallocated");
    [super dealloc];
}

#pragma mark - Actions

- (void)closeAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)themeOneAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = self.themes.theme1;
        self.navigationController.navigationBar.tintColor = UIColor.skyBlueColor;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self setNavBarTheme:self.themes.theme1];
    }];
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme1];
}

- (IBAction)themeTwoAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = self.themes.theme2;
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [self setNavBarTheme:self.themes.theme2];
    }];
    
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme2];
}

- (IBAction)themeThreeAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = self.themes.theme3;
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [self setNavBarTheme:self.themes.theme3];
    }];
    
    [self.delegate themesViewController:self didSelectTheme:self.themes.theme3];
}

#pragma mark - Helpers

- (void)setNavBarTheme:(UIColor*) color {
    self.navigationController.navigationBar.barTintColor = color;
}


@end




