//
//  OGActionPopup.h
//  OGActionPopupProject
//
//  Created by Jesper on 28/12/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGActionPopupDelegate.h"

@interface OGActionPopup : UIView

@property (weak, nonatomic)									id<OGActionPopupDelegate>	delegate;
@property (copy, nonatomic)									NSString*					title;
@property (copy, nonatomic)									NSString*					cancelText;
@property (assign, nonatomic, readonly)						NSInteger					numberOfButtons;
@property (assign, nonatomic, readonly, getter=isVisible)	BOOL						visible;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (NSInteger)addButtonWithTitle:(NSString *)title image:(UIImage *)image;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end
