//
//  OGActionPopup.h
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

@import UIKit;
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
