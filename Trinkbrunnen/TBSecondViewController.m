//
//  TBSecondViewController.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBSecondViewController.h"
#import "TBListViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerVisualState.h"

static CGFloat kDEFAULTCLUSTERSIZE = 0.05;
static NSUInteger kMINANNOTATIONCOUNT = 3;

@interface TBSecondViewController ()

@property (strong, nonatomic) NSMutableArray *overlays;
@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property BOOL viewAppeared;
@property (strong, nonatomic) UIBarButtonItem *saveRightBarButtonItem;
@property BOOL isUpdating;

@end

@implementation TBSecondViewController 

@synthesize model = _model;
@synthesize map = _map;
@synthesize overlays = _overlays;
@synthesize annotations = _annotations;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize annotationButton = _annotationButton;
@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize viewAppeared = _viewAppeared;
@synthesize mapStyleSegment = _mapStyleSegment;
@synthesize photoButton = _photoButton;
@synthesize saveRightBarButtonItem = _saveRightBarButtonItem;
@synthesize isUpdating = _isUpdating;

- (IBAction)setMapStyle:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 1:
            self.selectedSegmentIndex = sender.selectedSegmentIndex;
            self.map.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.selectedSegmentIndex = sender.selectedSegmentIndex;
            self.map.mapType = MKMapTypeHybrid;
            break;
        case 3:
            sender.selectedSegmentIndex = self.selectedSegmentIndex;
            self.model.currentLocation = self.model.locationManager.location;
            [self performSegueWithIdentifier:@"ListViewSegue" sender:self];
            break;
        default:
        case 0:
            self.selectedSegmentIndex = sender.selectedSegmentIndex;
            self.map.mapType = MKMapTypeStandard;
            break;
    }
}

- (void)startActivityIndicator:(NSString *)activity
{
    if (!self.isUpdating)
    {
        self.isUpdating = YES;
        self.saveRightBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.title = activity;
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
}

- (void)stopActivityIndicator
{
    self.navigationItem.rightBarButtonItem = self.saveRightBarButtonItem;
    self.navigationItem.title = self.title;
    self.isUpdating = NO;
}

- (void) getKmlData:(NSIndexPath *)indexPath
{
    long index = indexPath.section*10 + indexPath.row;
    [self.model initKmlWithIndex:index];
}

- (void) updateView
{
    if (self.model.selectedIndexPath)
    {
        [self startActivityIndicator:NSLocalizedString(@"Laden...", nil)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
        {
            [self getKmlData:self.model.selectedIndexPath];
            dispatch_async(dispatch_get_main_queue(), ^()
            {
                self.title = self.model.title;
                if (self.masterPopoverController != nil)
                {
                    [self.masterPopoverController dismissPopoverAnimated:YES];
                }
                [self showKML];
                [self stopActivityIndicator];
            });
        });
    }
}

- (IBAction)detailView:(UIButton *)sender
{
    //NSLog(@"%@", self.model.selectedAnnotation);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.viewAppeared = YES;
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        //MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];

        [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
        //[self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
        
        //[self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    [self setMapStyle:self.mapStyleSegment];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.map.delegate = self;
    
    if (!self.model)
    {
        self.model = [TBModel getInstance];
    }
    
    self.map.delegate = self;
    self.map.clusterSize = kDEFAULTCLUSTERSIZE;
    self.map.minimumAnnotationCountPerCluster = kMINANNOTATIONCOUNT;
    
    self.title = self.model.title;

    self.overlays = [[NSMutableArray alloc] init];
    
    [self.mapStyleSegment setTitle:NSLocalizedString(@"Karte", nil) forSegmentAtIndex:0];
    [self.mapStyleSegment setTitle:NSLocalizedString(@"Satellit", nil) forSegmentAtIndex:1];
    [self.mapStyleSegment setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
    [self.mapStyleSegment setTitle:NSLocalizedString(@"Liste", nil) forSegmentAtIndex:3];
    self.photoButton.title = NSLocalizedString(@"Fotos", nil);
    
    [self updateView];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.viewAppeared = NO;
    //self.map.showsUserLocation = NO;
    [self stopSignificantChangeUpdates];
    [super viewDidDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    self.map.delegate = nil;
    self.model.annotationIcon = nil;
    [self.model setAnnotations:nil];
    [self.model.locationManager setDelegate:nil];
    [self setModel:nil];
    [self setAnnotationButton:nil];
    [self setOverlays:nil];
    [self setAnnotations:nil];
    [self setMasterPopoverController:nil];
    [self setMapStyleSegment:nil];
    [self setPhotoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)startSignificantChangeUpdates
{
    self.model.locationManager.delegate = self;
    
    self.model.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.model.locationManager startMonitoringSignificantLocationChanges];
    [self.model.locationManager startUpdatingLocation];
}

- (void)stopSignificantChangeUpdates
{    
    if (self.model.locationManager)
    {
        self.model.locationManager.delegate = nil;
        [self.model.locationManager stopMonitoringSignificantLocationChanges];
        [self.model.locationManager stopUpdatingLocation];
    }
}

- (void) showLocationRegion
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.model.locationManager.location.coordinate.latitude;
    newRegion.center.longitude = self.model.locationManager.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    [self.map setRegion:newRegion animated:YES];
}

- (void) showOverlayRegion
{
    // Walk the list of annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo))
        {
            flyTo = pointRect;
        }
        else
        {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    self.map.visibleMapRect = flyTo;
}

- (void) showKML
{
    // Remove old Overlays and old Annotations
    [self.map removeAnnotations:self.annotations];
    [self.map removeOverlays:self.overlays];
    [self.overlays removeAllObjects];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    self.annotations = self.model.annotations;
    [self.map addAnnotations:self.annotations];
    
    if (CLLocationManager.locationServicesEnabled)
    {
        self.map.showsUserLocation = YES;
        [self startSignificantChangeUpdates];
        [self showLocationRegion];
    }
    else
    {
        self.map.showsUserLocation = NO;
        [self stopSignificantChangeUpdates];
        [self showOverlayRegion];
    }
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menü", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark - LocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.model.currentLocation = [locations lastObject];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showOverlayRegion];
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[OCAnnotation class]]) {
        // create your custom cluster annotationView here!
        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
        clusterAnnotation.title = self.title;
        clusterAnnotation.subtitle = [NSString stringWithFormat:NSLocalizedString(@"Anzahl Annotations", nil), [clusterAnnotation.annotationsInCluster count]];
        clusterAnnotation.groupTag = self.title;
        
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = NO;
        pinView.pinColor = MKPinAnnotationColorRed;

        CLLocationDistance distance = CLLocationCoordinateDistance(clusterAnnotation.maxCoordinate, clusterAnnotation.minCoordinate);
        double radius = distance / 2.0;
        
        //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        //MKCoordinateSpan span = self.map.region.span;
        //double radius = (UIDeviceOrientationIsLandscape(orientation) ? 1600.0*span.longitudeDelta : 2400.0*span.latitudeDelta);
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:annotation.coordinate radius:radius];
        [self.map addOverlay:circle];
        
        return pinView;
    }
    
    if ([annotation isKindOfClass:[TBAnnotation class]])
    {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = NO;
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.rightCalloutAccessoryView = self.annotationButton;
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    [self.map removeOverlays:self.overlays];
    [self.overlays removeAllObjects];
    [self.map doClustering];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.model.selectedAnnotation = view.annotation;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        [self.overlays addObject:overlay];

        MKCircleRenderer *cr = [[MKCircleRenderer alloc] initWithCircle:overlay];
        
        cr.fillColor = [UIColor colorWithRed:247/255.f green:85/255.f blue:86/255.f alpha:0.2];
        cr.lineWidth = 0.7;
        cr.strokeColor = [UIColor colorWithRed:247/255.f green:85/255.f blue:86/255.f alpha:1.0];
        
        return cr;
    }
    
    return nil;
}

@end
