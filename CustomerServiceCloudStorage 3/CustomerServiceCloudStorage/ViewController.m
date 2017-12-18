//
//  ViewController.m
//  CustomerServiceCloudStorage
//
//  Created by Nisha Raghu on 10/4/17.
//  Copyright © 2017 Nisha Raghu. All rights reserved.
//

#import "ViewController.h"
#import "FormViewController.h"

#define iCLoudKey @"AVAILABLE_RECORDS"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *records;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRecords];
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:store];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddRecord:)
                                                 name:kNotificationName_Add
                                               object:nil];

    [store synchronize];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.selectedIndex = NSUIntegerMax;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecords {
    NSLog(@" \n Loaded Records--- %@-----",self.records);
}



#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    label.text = [self.records objectAtIndex:indexPath.row];
    return cell;
}


- (NSArray *)records {
    if(_records)
        return _records;
    _records = [[[NSUbiquitousKeyValueStore defaultStore] arrayForKey:iCLoudKey] mutableCopy];
    if (!_records) {
        _records = [NSMutableArray array];
    }
    return _records;
}

- (void) storeDidChange:(NSNotification *)notification
{
    _records = [[[NSUbiquitousKeyValueStore defaultStore] arrayForKey:iCLoudKey] mutableCopy];
    
    NSLog(@" Store Did Change Called ----%@",self.records);

    [self.tableView reloadData];
}

- (void) didAddRecord:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *recordStr = [userInfo valueForKey:@"Record"];
    if (self.selectedIndex != NSUIntegerMax) {
        [self.records replaceObjectAtIndex:self.selectedIndex withObject:recordStr];
    } else {
        [self.records addObject:recordStr];
    }
    [[NSUbiquitousKeyValueStore defaultStore] setArray:self.records forKey:iCLoudKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    NSLog(@" Saved ---records--%@",self.records);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowRecordDetails"])
    {
        FormViewController *formController =
        [segue destinationViewController];
        
        NSIndexPath *selectedIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        formController.record = [self.records objectAtIndex:selectedIndexPath.row];
        self.selectedIndex = selectedIndexPath.row;
    }
}


@end
