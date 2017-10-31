//
//  YDQRCodeController.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDQRCodeController.h"
#import "YDQCScanManager.h"
#import <AVFoundation/AVFoundation.h>
#import "YDScanSuccessController.h"

@interface YDQRCodeController ()<YDQCScanManagerDelegate>



@end

@implementation YDQRCodeController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleString = @"扫码加入";
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupQRCodeScanning];
}

- (void)setupQRCodeScanning {
    YDQCScanManager *manager = YDQCCode;
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    [manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    manager.delegate = self;
}


#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(YDQCScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    
    DLog(@"metadataObjects - - %@", [metadataObjects firstObject]);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        [scanManager stopRunning];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];

        NSString *result = [obj stringValue];
        if ([result hasPrefix:@"http"]) {
            // 当扫描的二维码是网址
        } else {
            NSData *JSONData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            DLog(@"=========dic : %@", dic);
            NSString *hotelName = dic[@"hotelName"];
            YDScanSuccessController *vc = [[YDScanSuccessController alloc] init];
            
            vc.hotelName = hotelName;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"暂未识别出扫描的二维码" message: nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [scanManager videoPreviewLayerAddToSuperlayer];
            [scanManager startRunning];
        }];
        UIAlertAction *alerB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertC addAction:alertA];
        [alertC addAction:alerB];
        [self presentViewController:alertC animated:YES completion:nil];
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

@end
