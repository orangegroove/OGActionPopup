//
//  OGActionPopupDelegate.h
//  OGActionPopupProject
//
//  Created by Jesper on 28/12/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
OGActionPopup;

@protocol OGActionPopupDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionPopup:(OGActionPopup *)actionPopup clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionPopupCancel:(OGActionPopup *)actionPopup;

- (void)willPresentActionPopup:(OGActionPopup *)actionPopup;  // before animation and showing view
- (void)didPresentActionPopup:(OGActionPopup *)actionPopup;  // after animation

// if button is cancel button, buttonIndex is -1
- (void)actionPopup:(OGActionPopup *)actionPopup willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)actionPopup:(OGActionPopup *)actionPopup didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

