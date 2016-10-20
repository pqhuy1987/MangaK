//
//  Help.m
//  flashcard
//
//  Created by TUNG on 8/14/16.
//  Copyright © 2016 pqhuy1987. All rights reserved.
//

#import "Help.h"

@implementation Help

+ (UIActivityIndicatorView *)createSpinView:(UIView *)superView {
    UIActivityIndicatorView *spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinView.center = superView.center;
    spinView.color = [UIColor blackColor];
    [superView addSubview:spinView];
    return spinView;
}

@end
