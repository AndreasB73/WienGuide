//
//  TBDetailViewController.h
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 18.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBModel.h"

@interface TBDetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) TBModel *model;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

- (IBAction)showMaps:(UIBarButtonItem *)sender;
- (IBAction)shareLocation:(UIBarButtonItem *)sender;

@end
