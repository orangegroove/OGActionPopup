//
//  OGActionPopupButton.m
//
//  Created by Jesper <jesper@orangegroove.net>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
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
	return CGSizeMake(60.f, 94.f);
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
	
	CGRect frame			= {0.f, 60.f, 60.f, 34.f};
	_label					= [[UILabel alloc] initWithFrame:frame];
	_label.font				= [UIFont boldSystemFontOfSize:14.f];
	_label.textAlignment	= NSTextAlignmentCenter;
	_label.textColor		= self.tintColor;
	_label.backgroundColor	= UIColor.clearColor;
	_label.numberOfLines	= 2;
	
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
