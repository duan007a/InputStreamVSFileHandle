//
//  ViewController.m
//  CPUSample
//
//  Created by huaixu on 2018/5/15.
//  Copyright © 2018年 huaixu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readFiles:(id)sender {
    NSString *fp = [[NSBundle mainBundle] pathForResource:@"biye" ofType:@"mp4"];
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:fp];
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 5;
    
    NSError *error;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:fp error:&error];
    unsigned long long fileSize = [attr[NSFileSize] unsignedLongLongValue];
    int part = 1024;
    int defaultPartSize = fileSize / part;
    
    for (int i = 0; i < part; i++) {
        @autoreleasepool{
            [fh seekToFileOffset:i * fileSize / 1024];
            NSData *td = [fh readDataOfLength:defaultPartSize];
            while (queue.operationCount >= 5) {
                NSLog(@"操作队列中操作数大于等于5个");
            }
            
            [queue addOperationWithBlock:^{
                NSLog(@"%zi",td.length);
            }];
        }
    }
    
    [fh closeFile];
    [queue waitUntilAllOperationsAreFinished];
}

- (IBAction)readFile2:(id)sender {
    NSString *fp = [[NSBundle mainBundle] pathForResource:@"biye" ofType:@"mp4"];
    NSInputStream *is = [NSInputStream inputStreamWithFileAtPath:fp];
    [is open];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 5;
    
    NSError *error;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:fp error:&error];
    unsigned long long fileSize = [attr[NSFileSize] unsignedLongLongValue];
    int part = 1024;
    int defaultPartSize = fileSize / part;
    
    for (int i = 0; i < part; i++) {
        @autoreleasepool{
            uint8_t buff[defaultPartSize];
            memset(buff, 0, defaultPartSize);
            
            NSInteger flag = [is read:buff maxLength:defaultPartSize];
            if (flag == -1) {
                NSLog(@"卧槽出错啦");
            }
            while (queue.operationCount >= 5) {
                NSLog(@"操作队列中操作数大于等于5个");
            }
            
            [queue addOperationWithBlock:^{
                NSLog(@"%zi",defaultPartSize);
            }];
        }
        
    }
    
    [queue waitUntilAllOperationsAreFinished];
}


@end
