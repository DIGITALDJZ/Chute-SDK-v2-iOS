//
//  ListChutesViewController.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 08/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "ListChutesViewController.h"
#import "AssetsGridViewController.h"

@implementation ListChutesViewController
@synthesize chuteList;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetsGridViewController *assetsGridViewController = [[AssetsGridViewController alloc] init];
    [self.navigationController pushViewController:assetsGridViewController animated:YES];
    [assetsGridViewController setTitle:[[data objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [assetsGridViewController setChuteId:[[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
    [assetsGridViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[ChuteAPI shared] getMyChutesWithResponse:^(NSArray *arr) {
        if (data) {
            [data release], data = nil;
        }
        data = [arr retain];
        [chuteList reloadData];
    } andError:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
}

- (void)viewDidUnload
{
    [self setChuteList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [chuteList release];
    [super dealloc];
}
@end