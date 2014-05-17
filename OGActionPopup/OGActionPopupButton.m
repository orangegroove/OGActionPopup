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

@import QuartzCore;
#import "OGActionPopupButton.h"

@interface OGActionPopupButton ()

@property (strong, nonatomic) UIImageView*	imageView;
@property (strong, nonatomic) UILabel*		label;

@end
@implementation OGActionPopupButton

#pragma mark - Lifecycle

- (id)init
{
	CGRect frame = {0., 0., OGActionPopupButton.buttonSize};
	
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
	return CGSizeMake(60., 94.);
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
	
	_imageView						= [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 60., 60.)];
	_imageView.backgroundColor		= UIColor.clearColor;
	_imageView.layer.cornerRadius	= 30.;
	_imageView.layer.borderColor	= self.tintColor.CGColor;
	_imageView.layer.borderWidth	= 2.;
	_imageView.layer.masksToBounds	= YES;
	
	return _imageView;
}

- (UILabel *)label
{
	if (_label)
		return _label;
	
	_label					= [[UILabel alloc] initWithFrame:CGRectMake(0., 60., 60., 34.)];
	_label.font				= [UIFont boldSystemFontOfSize:14.];
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

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
	_imageEdgeInsets		= imageEdgeInsets;
	self.imageView.frame	= ({
		
		CGRect frame		= CGRectZero;
		frame.origin.x		= imageEdgeInsets.left;
		frame.origin.y		= imageEdgeInsets.top;
		frame.size.width	= 60. - imageEdgeInsets.left - imageEdgeInsets.right;
		frame.size.height	= 60. - imageEdgeInsets.top - imageEdgeInsets.bottom;
		
		frame;
	});
}

@end
