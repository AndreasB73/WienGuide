//
//  TBDetailViewController.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 18.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBDetailViewController.h"
#import "TBKMLParser.h"

@interface TBDetailViewController() <UIPopoverControllerDelegate>
@property BOOL popover;
@end

@implementation TBDetailViewController

@synthesize model = _model;
@synthesize map = _map;
@synthesize webView = _webView;
@synthesize popover = _popover;

#define FAVOURITES_KEY  @"WienGuide.Favourites"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    if (!self.model)
    {
        self.model = [TBModel getInstance];
    }
    [self.webView enableRoundRectsWithValue:5 borderWith:0.5 borderColor:[UIColor lightGrayColor]];
    [self.map enableRoundRectsWithValue:5 borderWith:0.5 borderColor:[UIColor lightGrayColor]];
    self.title = self.model.selectedAnnotation.title;
    [self showDetails];
    
    self.webView.delegate = self;
    self.popover = NO;
}

- (void) getKmlData:(NSIndexPath *)indexPath
{
    long index = indexPath.section*10 + indexPath.row;
    [self.model initKmlWithIndex:index];
}

-(void) showDetails
{
    NSString *text;
    id<MKAnnotation> pin = self.model.selectedAnnotation;
    CLLocationCoordinate2D coord = pin.coordinate;
    [self.map addAnnotation:pin];
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = coord.latitude;
    newRegion.center.longitude = coord.longitude;
    newRegion.span.latitudeDelta = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    [self.map setCenterCoordinate:coord];
    [self.map setRegion:newRegion animated:YES];
    
    if (self.model.selectedAnnotation.description.length == 0)
        text = self.title;
    else
        text = self.model.selectedAnnotation.description;
    
    [self.webView loadHTMLString:text
                         baseURL:[[NSURL alloc] initWithString:@"http://" ]];
    text = nil;
}


- (void)viewDidUnload {
    self.webView.delegate = nil;
    [self setMap:nil];
    [self setWebView:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (IBAction)showMaps:(UIBarButtonItem *)sender {
    CLLocationCoordinate2D coord = self.model.selectedAnnotation.coordinate;
    NSString *mapUrl = [[NSString alloc] initWithFormat:@"http://maps.apple.com/maps?q=%f,%f&t=k&z=19", coord.latitude, coord.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapUrl]];
}

- (IBAction)shareLocation:(UIBarButtonItem *)sender {
    CLLocationCoordinate2D coord = self.model.selectedAnnotation.coordinate;
    NSString *textToShare = [[NSString alloc] initWithFormat:@"%@ %@ %@ http://maps.apple.com/maps?q=%f,%f&t=k&z=19. %@",
                              NSLocalizedString(@"I like", nil),
                              self.title,
                              NSLocalizedString(@"in Vienna", nil),
                              coord.latitude,
                              coord.longitude,
                              NSLocalizedString(@"Sent from WienGuide", nil)
                              ];
    NSArray *activityItems = @[textToShare];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (!self.popover)
        {
            self.popover = YES;
            UIPopoverController *aPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            aPopoverController.delegate = self;
            [aPopoverController presentPopoverFromBarButtonItem:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = NO;
}


@end
