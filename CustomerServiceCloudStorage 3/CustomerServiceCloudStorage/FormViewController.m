//
//  FormViewController.m
//  CustomerServiceCloudStorage
//
//  Created by Nisha Raghu on 10/4/17.
//  Copyright © 2017 Nisha Raghu. All rights reserved.
//

#import "FormViewController.h"
#import "ViewController.h"

@interface FormViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *reasonField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveItem;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.record) {
        NSArray *infoArray = [self.record componentsSeparatedByString:@"-"];
        if (infoArray.count > 2) {
            self.descriptionTextView.text = infoArray[2];
        }
        if (infoArray.count > 1) {
            self.reasonField.text = infoArray[1];
        }
        if (infoArray.count > 0) {
            self.locationField.text = infoArray[0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC
{
    if ([unwindSegue.identifier isEqualToString:@"Cancel"]) {
        
    } else {
        NSLog(@" Save Call-----");
        
        NSString *location = self.locationField.text ?: @" ";
        NSString *reason = self.reasonField.text ?: @" ";
        NSString *description = self.descriptionTextView.text ?: @" ";
        NSString *record = [NSString stringWithFormat:@"%@-%@-%@",location,reason,description];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kNotificationName_Add
         object:self
         userInfo:@{@"Record":record}];
    }
}


@end
