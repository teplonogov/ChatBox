//
//  ThemesViewControllerDelegate.h
//  ChatBox
//
//  Created by Alexey Teplonogov on 12/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class ThemesViewController;
@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController*)controller didSelectTheme:(UIColor*)selectedTheme;

@end

NS_ASSUME_NONNULL_END
