//
//  TBModel.h
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMLParser.h"
#import "TBAnnotation.h"

@interface TBModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *annotationIcon;
@property (strong, nonatomic) UIImage *annotationImage;
@property (strong, nonatomic) TBAnnotation *selectedAnnotation;
@property long selectedKmlIndex;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSMutableArray *annotations;

- (void) initKml;
- (void) initKmlWithIndex:(long)kmlIndex;
- (void) initKmlWithString:(NSString *)kmlstring;

+ (TBModel *) getInstance;

@end
