//
//  TBFirstViewController.h
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBModel.h"
#import "TBSecondViewController.h"

@interface TBFirstViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) TBModel *model;
@property (strong, nonatomic) TBSecondViewController *detailViewController;

@end
