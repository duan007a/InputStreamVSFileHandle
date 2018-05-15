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
    queue.maxConcurrentOperationCount = 1;
    
    NSError *error;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:fp error:&error];
    unsigned long long fileSize = [attr[NSFileSize] unsignedLongLongValue];
    int part = 1024;
    int defaultPartSize = fileSize / part;
    
    for (int i = 0; i < part; i++) {
        [fh seekToFileOffset:i * fileSize / 1024];
        NSData *td = [fh readDataOfLength:defaultPartSize];
        while (queue.operationCount >= 5) {
            
        }
        
        [queue addOperationWithBlock:^{
            printf("%zd",td.length);
        }];
    }
    
    [fh closeFile];
    [queue waitUntilAllOperationsAreFinished];
}

- (IBAction)readFile2:(id)sender {
    NSString *fp = [[NSBundle mainBundle] pathForResource:@"biye" ofType:@"mp4"];
    NSInputStream *is = [NSInputStream inputStreamWithFileAtPath:fp];
    [is open];
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
    
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
                printf("卧槽出错啦");
            }
            while (queue.operationCount >= 5) {
                
            }
            
            [queue addOperationWithBlock:^{
                printf("%zd",defaultPartSize);
            }];
        }
        
    }
    
    [queue waitUntilAllOperationsAreFinished];
}


@end
