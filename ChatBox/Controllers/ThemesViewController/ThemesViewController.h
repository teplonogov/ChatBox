//
//  ThemesViewController.h
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface ThemesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *themeOneButton;
@property (weak, nonatomic) IBOutlet UIButton *themeTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *themeThreeButton;

@property (nonatomic, weak) id <ThemesViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
