//
//  OGActionPopup.m
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

#import "OGActionPopup.h"
#import "OGActionPopupButton.h"

#define BUTTON_YPADDING				20.f
#define TITLE_FADE_DURATION			0.3
#define CANCELBUTTON_FADE_DURATION	0.3
#define BACKGROUND_FADE_DURATION	0.2
#define BUTTON_MOVE_DURATION		0.8
#define BUTTON_MOVE_DELAY			0.1

typedef NS_ENUM(int8_t, OGActionPopupButtonState)
{
	OGActionPopupButtonStateInitial,
	OGActionPopupButtonStateDisplayed,
	OGActionPopupButtonStateDismissed
};

typedef struct
{
	BOOL	clickedButtonAtIndex;
	BOOL	cancel;
	BOOL	willPresent;
	BOOL	didPresent;
	BOOL	willDismissWithButtonIndex;
	BOOL	didDismissWithButtonIndex;
	
} OGActionPopupDelegateMethods;

@interface OGActionPopup ()

@property (assign, nonatomic) OGActionPopupDelegateMethods	delegateMethods;
@property (strong, nonatomic) UITapGestureRecognizer*		tapGestureRecognizer;
@property (strong, nonatomic) NSMutableArray*				buttons;
@property (strong, nonatomic) UILabel*						titleLabel;
@property (strong, nonatomic) UIButton*						cancelButton;

- (void)presentWithCompletion:(void (^)(void))completion;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setCancelButtonVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay;
- (void)setTitleVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay;
- (void)setBackgroundColorVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay;

- (void)moveButtonsAnimated:(BOOL)animated from:(OGActionPopupButtonState)fromState to:(OGActionPopupButtonState)toState delayIndex:(NSInteger)delayIndex completion:(void (^)(void))completion;
- (CGPoint)centerForButtonAtIndex:(NSInteger)index state:(OGActionPopupButtonState)state;

@end
@implementation OGActionPopup

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
	return [self init];
}

- (id)init
{
	CGRect frame = UIScreen.mainScreen.applicationFrame;
	
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor		= UIColor.clearColor;
		self.userInteractionEnabled	= YES;
		
		[self addSubview:self.titleLabel];
		[self addSubview:self.cancelButton];
		[self addGestureRecognizer:self.tapGestureRecognizer];
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Public

- (void)show
{
	if (self.delegateMethods.willPresent)
		[self.delegate willPresentActionPopup:self];
	
	__weak OGActionPopup* wself = self;
	
	[self presentWithCompletion:^{
		
		if (wself.delegateMethods.didPresent)
			[wself.delegate didPresentActionPopup:wself];
	}];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if (self.delegateMethods.willDismissWithButtonIndex)
		[self.delegate actionPopup:self willDismissWithButtonIndex:buttonIndex];
	
	__weak OGActionPopup* wself = self;
	
	[self dismissWithClickedButtonIndex:buttonIndex animated:animated completion:^{
		
		if (wself.delegateMethods.didDismissWithButtonIndex)
			[wself.delegate actionPopup:wself didDismissWithButtonIndex:buttonIndex];
	}];
}

- (NSInteger)addButtonWithTitle:(NSString *)title image:(UIImage *)image
{
	OGActionPopupButton* button = [[OGActionPopupButton alloc] init];
	button.title				= title;
	button.image				= image;
	
	[self.buttons addObject:button];
	
	if (self.isVisible) {
		
		[self addSubview:button];
		[self setNeedsLayout];
	}
	
	return self.numberOfButtons - 1;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
	return ((OGActionPopupButton *)self.buttons[buttonIndex]).title;
}

#pragma mark - Events

- (void)tintColorDidChange
{
	self.titleLabel.textColor = self.tintColor;
	
	[self.cancelButton setTitleColor:self.tintColor forState:UIControlStateNormal];
	
	for (OGActionPopupButton* button in self.buttons)
		button.tintColor = self.tintColor;
}

- (void)tapGestureRecognizerTrigger:(UITapGestureRecognizer *)tapGestureRecognizer
{
	if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		
		CGPoint point = [tapGestureRecognizer locationInView:self];
		
		for (NSInteger i = 0; i < self.buttons.count; i++) {
			
			OGActionPopupButton* button	= self.buttons[i];
			
			if (CGRectContainsPoint(button.frame, point)) {
				
				[self dismissWithClickedButtonIndex:i animated:YES];
				return;
			}
		}
		
		[self dismissWithClickedButtonIndex:-1 animated:YES];
	}
}

- (void)cancelButtonTapped:(UIButton *)button
{
	[self dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)applicationDidEnterBackground:(NSNotification *)note
{
	if (self.delegateMethods.cancel)
		[self.delegate actionPopupCancel:self];
	else
		[self dismissWithClickedButtonIndex:-1 animated:YES];
}

#pragma mark - Private

- (void)presentWithCompletion:(void (^)(void))completion
{
	[UIApplication.sharedApplication.keyWindow addSubview:self];
	[self moveButtonsAnimated:YES from:OGActionPopupButtonStateInitial to:OGActionPopupButtonStateDisplayed delayIndex:-1 completion:completion];
	[self setCancelButtonVisible:YES animated:YES delay:0.3];
	[self setTitleVisible:YES animated:YES delay:0.3];
	[self setBackgroundColorVisible:YES animated:YES delay:0.];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion
{
	__weak OGActionPopup* wself = self;
	
	[self moveButtonsAnimated:animated from:OGActionPopupButtonStateDisplayed to:OGActionPopupButtonStateDismissed delayIndex:buttonIndex completion:^{
		
		[wself removeFromSuperview];
		
		completion();
	}];
	[self setCancelButtonVisible:NO animated:animated delay:0.];
	[self setTitleVisible:NO animated:animated delay:0.3];
	[self setBackgroundColorVisible:NO animated:animated delay:0.5];
}

- (void)setTitleVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay
{
	CGFloat alpha = visible? 1.f : 0.f;
	
	if (animated)
		[UIView animateWithDuration:TITLE_FADE_DURATION delay:delay options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionBeginFromCurrentState animations:^{
			
			self.titleLabel.alpha = alpha;
			
		} completion:^(BOOL finished) {
			
		}];
	else
		self.titleLabel.alpha = alpha;
}

- (void)setCancelButtonVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay
{
	CGFloat halfHeight	= CGRectGetHeight(self.cancelButton.frame) / 2;
	CGFloat y			= visible? CGRectGetHeight(self.bounds) - halfHeight : CGRectGetHeight(self.bounds) + halfHeight;
	
	if (animated)
		[UIView animateWithDuration:CANCELBUTTON_FADE_DURATION delay:delay options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionBeginFromCurrentState animations:^{
			
			self.cancelButton.center = CGPointMake(self.cancelButton.center.x, y);
			
		} completion:^(BOOL finished) {
			
		}];
	else
		self.cancelButton.center = CGPointMake(self.cancelButton.center.x, y);
}

- (void)setBackgroundColorVisible:(BOOL)visible animated:(BOOL)animated delay:(NSTimeInterval)delay
{
	UIColor* color = visible? [UIColor.blackColor colorWithAlphaComponent:0.8f] : UIColor.clearColor;
	
	if (animated)
		[UIView animateWithDuration:BACKGROUND_FADE_DURATION delay:delay options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionBeginFromCurrentState animations:^{
			
			self.backgroundColor = color;
			
		} completion:^(BOOL finished) {
			
		}];
	else
		self.backgroundColor = color;
}

- (void)moveButtonsAnimated:(BOOL)animated from:(OGActionPopupButtonState)fromState to:(OGActionPopupButtonState)toState delayIndex:(NSInteger)delayIndex completion:(void (^)(void))completion
{
	NSMutableArray* delays = [NSMutableArray array];
	
	for (NSInteger i = 0; i < self.buttons.count; i++) {
		[delays addObject:@(i * BUTTON_MOVE_DELAY)];
	}
	
	if (delayIndex >= 0) {
		
		NSNumber* delay = delays.lastObject;
		
		[delays removeLastObject];
		[delays insertObject:delay atIndex:delayIndex];
	}
	
	for (NSInteger i = 0; i < self.buttons.count; i++) {
		
		OGActionPopupButton* button = self.buttons[i];
		button.center				= [self centerForButtonAtIndex:i state:fromState];
		NSTimeInterval delay		= ((NSNumber *)delays[i]).doubleValue;
		
		[self addSubview:button];
		
		if (animated)
			[UIView animateWithDuration:BUTTON_MOVE_DURATION delay:delay usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
				
				button.center = [self centerForButtonAtIndex:i state:toState];
				
			} completion:^(BOOL finished) {
				
				if (i == self.buttons.count-1)
					completion();
			}];
		else
			button.center = [self centerForButtonAtIndex:i state:toState];
	}
}

- (CGPoint)centerForButtonAtIndex:(NSInteger)index state:(OGActionPopupButtonState)state
{
	CGPoint point;
	NSInteger columns		= 3;
	NSInteger rows			= (NSInteger)ceilf(self.buttons.count / (float)columns);
	NSInteger column		= index % columns;
	NSInteger row			= (NSInteger)floorf(index / (float)columns);
	NSInteger lastRowStart	= columns * (rows - 1);
	NSInteger columnsOnRow	= index < lastRowStart? columns : self.buttons.count - lastRowStart;
	CGFloat yoffset			= 0.f;
	
	// y
	switch (state) {
		case OGActionPopupButtonStateInitial:
			
			yoffset = CGRectGetHeight(self.bounds);
			break;
			
		case OGActionPopupButtonStateDismissed:
			
			yoffset = -CGRectGetHeight(self.bounds);
			break;
			
		case OGActionPopupButtonStateDisplayed: {
			
			yoffset = CGRectGetMaxY(self.titleLabel.frame) + BUTTON_YPADDING*2;
			break;
		}
	}
	
	point.y = yoffset + (row * (OGActionPopupButton.buttonSize.height + BUTTON_YPADDING)) + BUTTON_YPADDING;
	
	// x
	CGFloat mid			= CGRectGetMidX(self.bounds);
	CGFloat left		= CGRectGetWidth(self.bounds) / 6;
	CGFloat right		= CGRectGetWidth(self.bounds) - left;
	CGFloat midleft		= CGRectGetWidth(self.bounds) / 3;
	CGFloat midright	= CGRectGetWidth(self.bounds) - midleft;
	
	switch (columnsOnRow) {
		case 1:
			
			point.x = mid;
			break;
			
		case 2:
			
			point.x = column == 0? midleft : midright;
			break;
			
		case 3: {
			
			switch (column) {
				case 0:
					
					point.x = left;
					break;
					
				case 1:
					
					point.x = mid;
					break;
					
				case 2:
					
					point.x = right;
					break;
			}
			break;
		}
	}
	
	return CGPointMake(roundf(point.x), roundf(point.y));
}

#pragma mark - Properties

- (UITapGestureRecognizer *)tapGestureRecognizer
{
	if (_tapGestureRecognizer)
		return _tapGestureRecognizer;
	
	_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerTrigger:)];
	
	return _tapGestureRecognizer;
}

- (NSMutableArray *)buttons
{
	if (_buttons)
		return _buttons;
	
	_buttons = [NSMutableArray array];
	
	return _buttons;
}

- (UILabel *)titleLabel
{
	if (_titleLabel)
		return _titleLabel;
	
	CGRect frame					= {BUTTON_YPADDING, BUTTON_YPADDING, CGRectGetWidth(self.bounds) - BUTTON_YPADDING*2, 60.f};
	_titleLabel						= [[UILabel alloc] initWithFrame:frame];
	_titleLabel.font				= [UIFont boldSystemFontOfSize:16.f];
	_titleLabel.textAlignment		= NSTextAlignmentCenter;
	_titleLabel.textColor			= self.tintColor;
	_titleLabel.backgroundColor		= UIColor.clearColor;
	_titleLabel.numberOfLines		= 0;
	_titleLabel.alpha				= 0.f;
	_titleLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
	
	return _titleLabel;
}

- (UIControl *)cancelButton
{
	if (_cancelButton)
		return _cancelButton;
	
	_cancelButton					= [UIButton buttonWithType:UIButtonTypeCustom];
	_cancelButton.frame				= CGRectMake(0.f, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 50.f);
	_cancelButton.backgroundColor	= [UIColor.blackColor colorWithAlphaComponent:0.2f];
	_cancelButton.autoresizingMask	= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
	
	[_cancelButton setTitleColor:self.tintColor forState:UIControlStateNormal];
	[_cancelButton setTitle:self.cancelText forState:UIControlStateNormal];
	[_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	return _cancelButton;
}

- (void)setDelegate:(id<OGActionPopupDelegate>)delegate
{
	_delegateMethods.clickedButtonAtIndex		= [delegate respondsToSelector:@selector(actionPopup:clickedButtonAtIndex:)];
	_delegateMethods.cancel						= [delegate respondsToSelector:@selector(actionPopupCancel:)];
	_delegateMethods.willPresent				= [delegate respondsToSelector:@selector(willPresentActionPopup:)];
	_delegateMethods.didPresent					= [delegate respondsToSelector:@selector(didPresentActionPopup:)];
	_delegateMethods.willDismissWithButtonIndex	= [delegate respondsToSelector:@selector(actionPopup:willDismissWithButtonIndex:)];
	_delegateMethods.didDismissWithButtonIndex	= [delegate respondsToSelector:@selector(actionPopup:didDismissWithButtonIndex:)];
	_delegate									= delegate;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
	
	if (self.isVisible)
		[self setNeedsLayout];
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setCancelText:(NSString *)cancelText
{
	[self.cancelButton setTitle:cancelText forState:UIControlStateNormal];
	
	if (self.isVisible)
		[self setNeedsLayout];
}

- (NSString *)cancelText
{
	return [self.cancelButton titleForState:UIControlStateNormal];
}

- (NSInteger)numberOfButtons
{
	return self.buttons.count;
}

- (BOOL)isVisible
{
	return !!self.superview;
}

@end
