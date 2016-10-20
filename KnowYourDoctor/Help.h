//
//  Help.h
//  flashcard
//
//  Created by TUNG on 8/14/16.
//  Copyright © 2016 pqhuy1987. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface Help : NSObject

+ (UIActivityIndicatorView *)createSpinView:(UIView *)superView;

@end
