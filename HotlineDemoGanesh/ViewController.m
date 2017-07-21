//
//  ViewController.m
//  HotlineDemoGanesh
//
//  Created by Tarun Sharma on 19/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "ViewController.h"
#import "Hotline.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.chatButtonInstance setExclusiveTouch:YES];
    [self.chatButtonInstance.layer setMasksToBounds:YES];
    [self.chatButtonInstance.layer setCornerRadius:12.0f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chatWithAgentButtonClick:(id)sender {
    [[Hotline sharedInstance]showConversations:self];
}


@end
