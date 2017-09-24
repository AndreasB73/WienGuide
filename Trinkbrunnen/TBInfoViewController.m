//
//  TBInfoViewController.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 21.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBInfoViewController.h"

@interface TBInfoViewController ()

@end

@implementation TBInfoViewController

@synthesize infoText = _infoText;
@synthesize infoImage = _infoImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     
    [self.infoText enableRoundRectsWithValue:5 borderWith:0.5 borderColor:[UIColor lightGrayColor]];
    [self.infoImage enableRoundRectsWithValue:5 borderWith:0.5 borderColor:[UIColor lightGrayColor]];
}

- (void)viewDidUnload
{
    [self setInfoText:nil];
    [self setInfoImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
