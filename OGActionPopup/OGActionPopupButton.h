//
//  OGActionPopupButton.h
//  OGActionPopupProject
//
//  Created by Jesper on 28/12/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OGActionPopupButton : UIView

@property (strong, nonatomic)	UIImage*	image;
@property (copy, nonatomic)		NSString*	title;

+ (CGSize)buttonSize;

@end
