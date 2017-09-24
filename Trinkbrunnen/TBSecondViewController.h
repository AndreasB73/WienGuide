//
//  TBSecondViewController.h
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMLParser.h"
#import "TBModel.h"
#import "OCMapView.h"

@interface TBSecondViewController : UIViewController
                        <CLLocationManagerDelegate, UISplitViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) TBModel *model;
@property (strong, nonatomic) IBOutlet OCMapView *map;
@property (strong, nonatomic) IBOutlet UIButton *annotationButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapStyleSegment;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *photoButton;

- (IBAction)setMapStyle:(UISegmentedControl *)sender;
- (IBAction)detailView:(UIButton *)sender;

- (void) updateView;

@end
