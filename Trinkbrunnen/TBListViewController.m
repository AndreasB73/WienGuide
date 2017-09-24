//
//  TBListViewController.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 07.10.12.
//
//

#import "TBListViewController.h"

@interface TBTableData : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) id<MKAnnotation> annotation;
@end

@implementation TBTableData
@synthesize text = _text;
@synthesize detailText = _detailText;
@synthesize annotation = _annotation;
@end


@interface TBListViewController ()

@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) NSMutableArray *tableText;
@end

@implementation TBListViewController

@synthesize model = _model;
@synthesize annotations = _annotations;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!self.model)
    {
        self.model = [TBModel getInstance];
    }
    
    self.title = self.model.title;
    self.annotations = self.model.annotations;
    self.tableText = [[NSMutableArray alloc] initWithCapacity:self.annotations.count];
    [self setSortedTableData];
}

- (void) setSortedTableData
{
    for (id<MKAnnotation> annotation in self.annotations)
    {
        TBTableData *row = [[TBTableData alloc] init];
        row.text = annotation.title;
        if (self.model.currentLocation)
        {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[annotation coordinate].latitude
                                                              longitude:[annotation coordinate].longitude];
        
            float distance =[self.model.currentLocation distanceFromLocation:location]/1000;
            row.detailText = [[NSString alloc] initWithFormat:@"%6.3f km",distance];        // Entfernung berechnen
            
        }
        else
        {
                row.detailText = @"";
        }

        row.annotation = annotation;
        [self.tableText addObject:row];
    }
    
    NSSortDescriptor *sorter;
    sorter = [[NSSortDescriptor alloc]initWithKey:@"detailText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sorter];
    [self.tableText sortUsingDescriptors:sortDescriptors];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setTableText:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    TBTableData *row = [self.tableText objectAtIndex:indexPath.row];
    cell.textLabel.text = row.text;
    cell.detailTextLabel.text = row.detailText;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBTableData *row = [self.tableText objectAtIndex:indexPath.row];
    self.model.selectedAnnotation = row.annotation;
    return indexPath;
}

@end
