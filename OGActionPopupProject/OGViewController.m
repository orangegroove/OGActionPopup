//
//  OGViewController.m
//  OGActionPopupProject
//
//  Created by Jesper on 30/12/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import "OGViewController.h"
#import "OGActionPopup.h"

@interface OGViewController ()



@end
@implementation OGViewController

#pragma mark - Lifecycle

- (id)init
{
	if (self = [super init]) {
		
	}
	
	return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor	= UIColor.whiteColor;
	UIButton* button			= [UIButton buttonWithType:UIButtonTypeSystem];
	button.frame				= CGRectMake(60.f, 200.f, 200.f, 60.f);
	
	[button setTitle:@"Show" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:button];
}

#pragma mark - OGActionPopupDelegate

- (void)actionPopup:(OGActionPopup *)actionPopup clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"OGActionPopup: did dismiss with button %ld", (long)buttonIndex);
}

- (void)actionPopupCancel:(OGActionPopup *)actionPopup
{
	NSLog(@"OGActionPopup: cancelled");
}

- (void)willPresentActionPopup:(OGActionPopup *)actionPopup
{
	NSLog(@"OGActionPopup: will present");
}

- (void)didPresentActionPopup:(OGActionPopup *)actionPopup
{
	NSLog(@"OGActionPopup: did present");
}

- (void)actionPopup:(OGActionPopup *)actionPopup willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"OGActionPopup: will dismiss with %ld", (long)buttonIndex);
}

- (void)actionPopup:(OGActionPopup *)actionPopup didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"OGActionPopup: did dismiss with %ld", (long)buttonIndex);
}

#pragma mark - Events

- (void)buttonTapped:(UIButton *)sender
{
	OGActionPopup* popup	= [[OGActionPopup alloc] init];
	popup.delegate			= self;
	popup.cancelText		= @"cancel text";
	popup.title				= @"this is the title";
	popup.tintColor			= UIColor.whiteColor;
	
	[popup addButtonWithTitle:@"button 1" image:[UIImage imageNamed:@"lorempixel1.jpeg"]];
	[popup addButtonWithTitle:@"button 2" image:[UIImage imageNamed:@"lorempixel2.jpeg"]];
	[popup addButtonWithTitle:@"button 3" image:[UIImage imageNamed:@"lorempixel3.jpeg"]];
	[popup addButtonWithTitle:@"button 4" image:[UIImage imageNamed:@"lorempixel4.jpeg"]];
	[popup addButtonWithTitle:@"button 5" image:[UIImage imageNamed:@"lorempixel5.jpeg"]];
	[popup addButtonWithTitle:@"button 6" image:[UIImage imageNamed:@"lorempixel1.jpeg"]];
	[popup addButtonWithTitle:@"button 7" image:[UIImage imageNamed:@"lorempixel2.jpeg"]];
	[popup addButtonWithTitle:@"button 8" image:[UIImage imageNamed:@"lorempixel3.jpeg"]];
	[popup addButtonWithTitle:@"button 9" image:[UIImage imageNamed:@"lorempixel4.jpeg"]];
	[popup show];
}

@end
