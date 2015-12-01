//
//  YBScanCode.m
//  test
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBScanCode.h"
#import <AVFoundation/AVFoundation.h>

/// 中间扫描大小
#define YBScanCodeSize 200

@interface YBScanCode () <AVCaptureMetadataOutputObjectsDelegate>
/// 会话
@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation YBScanCode

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 设置导航栏
    [self setNaviagtionBar];
    // 设置区域
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat x = (screenSize.width - YBScanCodeSize) * 0.5;
    CGFloat y = (screenSize.height - YBScanCodeSize) * 0.5;
    CGFloat wid = YBScanCodeSize;
    CGFloat hei = YBScanCodeSize;
    // 开始捕获数据
    [self beginScanning:CGRectMake(x, y, wid, hei)];
    // 设置阴影
    [self setShawow:CGRectMake(x, y, wid, hei)];
}

/// 设置导航栏
- (void)setNaviagtionBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的二维码" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}

#pragma mark - 按钮点击事件
/// 左边导航栏按钮点击
- (void)leftBarButtonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 右边导航栏按钮点击
- (void)rightBarButtonItemClick{
    // 将二维码显示在手机屏幕上
    UIImage *image = [YBScanCode imageWithContentString:@"邹玲吃屎" andScale:10 andCenterIcon:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    // 设置大小
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat imageViewX = (screenSize.width - image.size.width) * 0.5;
    imageView.frame = CGRectMake(imageViewX, 100, image.size.width, image.size.height);
}

/// 开始捕获数据
- (void)beginScanning:(CGRect)rect
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 如果输入流不可用直接返回
    if (!input){
        [self popAlertView];
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    // 设置扫描区域
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat x = rect.origin.x / screenSize.width;
    CGFloat y = rect.origin.y / screenSize.height;
    CGFloat wid = rect.size.width / screenSize.width;
    CGFloat hei = rect.size.height / screenSize.height;
    output.rectOfInterest = CGRectMake(y, x, hei, wid);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加输入输出
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // 输出试图
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

#pragma mark - 捕获到数据代理
/// 捕获到数据就会调用
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        /// 获取返回结果
        [self scanCodeResooult:metadataObject.stringValue];
    }
}

#pragma mark - 弹窗
/// 创建弹窗（当摄像头不可用弹窗）
- (void)popAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"摄像头不可用" message:@"请去设置里面允许使用摄像头" preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self leftBarButtonItemClick];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 扫描结果弹窗
- (void)scanCodeResooult:(NSString *)resoult {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描信息" message:resoult preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self leftBarButtonItemClick];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 设置边上的角
- (void)setShawow:(CGRect)rect {
    // 左上角
    UIImageView *leftTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_1"]];
    // 设置位置
    leftTopView.frame = CGRectMake(rect.origin.x, rect.origin.y, 19, 19);
    // 添加
    [self.view addSubview:leftTopView];
    
    // 右上角
    UIImageView *rightTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_2"]];
    // 设置位置
    CGFloat rightTopViewX = rect.origin.x + rect.size.width - 19;
    rightTopView.frame = CGRectMake(rightTopViewX, rect.origin.y, 19, 19);
    // 添加
    [self.view addSubview:rightTopView];
    
    // 左下角
    UIImageView *leftBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_3"]];
    // 设置位置
    CGFloat rightTopViewY = rect.origin.y + rect.size.height - 19;
    leftBottomView.frame = CGRectMake(rect.origin.x, rightTopViewY, 19, 19);
    // 添加
    [self.view addSubview:leftBottomView];
    
    // 左下角
    UIImageView *rightBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_4"]];
    // 设置位置
    CGFloat rightBottomViewX = rect.origin.x + rect.size.width - 19;
    CGFloat rightBottomViewY = rect.origin.y + rect.size.height - 19;
    rightBottomView.frame = CGRectMake(rightBottomViewX, rightBottomViewY, 19, 19);
    // 添加
    [self.view addSubview:rightBottomView];
}

#pragma mark - 创建二维码
// 创建二维码
// 参数1：要编码的数据
// 参数2：二维码放大倍数
// 参数2：中间的小图片
+ (UIImage *)imageWithContentString:(NSString *)conStr andScale:(CGFloat)scale andCenterIcon:(UIImage *)cenIcon{
    // 创建对应二维码功能的滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 把数据输入给滤镜
    NSData *data = [conStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    // 导出CIImage图片
    CIImage *ciImage = [filter outputImage];
    // 放大图片, 10倍
    CIImage *transformImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    // 向中间添加头像
    UIImage *originalImage = [UIImage imageWithCIImage:transformImage];
    // 如果需要添加头像就运行
    if (cenIcon) {
        // 画图, 在中间再一个头像
        CGSize size = originalImage.size;
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size);
        // 2. 画原图
        [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 3. 画头像, 画在中单, 大小%20
        CGFloat wh = size.width * 0.2;
        [cenIcon drawInRect:CGRectMake((size.width - wh) / 2, (size.height - wh) / 2, wh, wh)];
        // 4. 取出图片
        originalImage = UIGraphicsGetImageFromCurrentImageContext();
        // 5. 关闭上下文
        UIGraphicsEndImageContext();
    }
    return originalImage;
}

/// 对象销毁
- (void)dealloc {
    NSLog(@"%s - 销毁",__FUNCTION__);
}

@end
