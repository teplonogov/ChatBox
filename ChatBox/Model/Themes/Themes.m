//
//  Themes.m
//  ChatBox
//
//  Created by Alexey Teplonogov on 12/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (void)setTheme1:(UIColor *)theme1 {
    [theme1 retain];
    [_theme1 release];
    _theme1 = theme1;
}

- (void)setTheme2:(UIColor *)theme2 {
    [theme2 retain];
    [_theme2 release];
    _theme2 = theme2;
}

- (void)setTheme3:(UIColor *)theme3 {
    [theme3 retain];
    [_theme3 release];
    _theme3 = theme3;
    
}

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}

@end
