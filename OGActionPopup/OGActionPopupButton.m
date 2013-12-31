//
//  OGActionPopupButton.m
//  OGActionPopupProject
//
//  Created by Jesper on 28/12/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OGActionPopupButton.h"

@interface OGActionPopupButton ()

@property (strong, nonatomic) UIImageView*	imageView;
@property (strong, nonatomic) UILabel*		label;

@end
@implementation OGActionPopupButton

#pragma mark - Lifecycle

- (id)init
{
	CGRect frame = {0.f, 0.f, OGActionPopupButton.buttonSize};
	
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = UIColor.clearColor;
		
		[self addSubview:self.imageView];
		[self addSubview:self.label];
	}
	
	return self;
}

#pragma mark - Public

+ (CGSize)buttonSize
{
	return CGSizeMake(60.f, 90.f);
}

#pragma mark - Events

- (void)tintColorDidChange
{
	self.imageView.layer.borderColor	= self.tintColor.CGColor;
	self.label.textColor				= self.tintColor;
}

#pragma mark - Properties

- (UIImageView *)imageView
{
	if (_imageView)
		return _imageView;
	
	CGRect frame					= {0.f, 0.f, 60.f, 60.f};
	_imageView						= [[UIImageView alloc] initWithFrame:frame];
	_imageView.layer.cornerRadius	= 30.f;
	_imageView.layer.borderColor	= self.tintColor.CGColor;
	_imageView.layer.borderWidth	= 2.f;
	_imageView.layer.masksToBounds	= YES;
	
	return _imageView;
}

- (UILabel *)label
{
	if (_label)
		return _label;
	
	CGRect frame			= {0.f, 60.f, 60.f, 30.f};
	_label					= [[UILabel alloc] initWithFrame:frame];
	_label.font				= [UIFont boldSystemFontOfSize:14.f];
	_label.textAlignment	= NSTextAlignmentCenter;
	_label.textColor		= self.tintColor;
	_label.backgroundColor	= UIColor.clearColor;
	
	return _label;
}

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (void)setTitle:(NSString *)title
{
	self.label.text = title;
}

- (NSString *)title
{
	return self.label.text;
}

@end
