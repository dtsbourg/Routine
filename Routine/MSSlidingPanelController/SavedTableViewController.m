//
//  SavedTableViewController.m
//  daily
//
//  Created by Dylan Bourgeois on 21/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "SavedTableViewController.h"

@interface SavedTableViewController ()
{
    NSArray*liked;
}

@end

@implementation SavedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.font = [UIFont fontWithName:@"CODE-Light" size:50];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (liked ==NULL)
    liked = [[NSArray alloc] initWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"liked"]];
    else liked =[[NSUserDefaults standardUserDefaults] objectForKey:@"liked"];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [liked count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"CODE-Bold" size:18];
    cell.textLabel.text = liked[indexPath.row][0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = liked[indexPath.row][1];
    cell.detailTextLabel.font = [UIFont fontWithName:@"CODE-Light" size:12];
    cell.detailTextLabel.textColor = [UIColor whiteColor];


    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
