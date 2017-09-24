//
//  TBFirstViewController.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBFirstViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface TBFirstViewController ()

@property BOOL bannerIsVisible;

@end

@implementation TBFirstViewController

@synthesize model = _model;
@synthesize detailViewController = _detailViewController;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!self.model)
    {
        self.model = [TBModel getInstance];
    }
    
    self.detailViewController = (TBSecondViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload
{
    [self setModel:nil];
    [self setDetailViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.selectedIndexPath = indexPath;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        UINavigationController *navC = (UINavigationController *)self.mm_drawerController.centerViewController;
        TBSecondViewController *mapVC = (TBSecondViewController *)navC.topViewController;
        [mapVC updateView];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    else
    {
        if (self.detailViewController)
        {
            [self.detailViewController updateView];
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section)
    {
        case 0:
            title = NSLocalizedString(@"Gesundheit & Hygiene", nil);
            break;
        case 1:
            title = NSLocalizedString(@"Internet", nil);
            break;
        case 2:
            title = NSLocalizedString(@"Spiel & Sport", nil);
            break;
        case 3:
            title = NSLocalizedString(@"Ausflüge", nil);
            break;
        case 4:
            title = NSLocalizedString(@"Kultur", nil);
            break;
        case 5:
            title = NSLocalizedString(@"Verkehr", nil);
            break;
        case 6:
            title = NSLocalizedString(@"Sonstiges", nil);
            break;
    }
    return title;
}

@end
