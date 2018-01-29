//
//  XFToolManager.m
//  shilitaohua
//
//  Created by mr.zhou on 2017/8/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFToolManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CoreText/CoreText.h>
#import <Photos/Photos.h>
#import <Accelerate/Accelerate.h>
//#import "UIImage+GIF.h"

@implementation XFToolManager

+ (void)statusBarHidhen:(BOOL)hidden {
    [UIView animateWithDuration:0.2 animations:^{
        //获取到状态栏
        UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
        //设置透明度为0
        if (hidden) {
            statusBar.alpha = 0;

        } else {
            statusBar.alpha = 1;

        }
    }];
    
}

+ (NSString *)changeLongToDateWith:(id)dateObj {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateObj longValue]/1000];
    
//
//
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    return [self changeDateToStringWithDate:date];
    
}

+ (MJRefreshGifHeader *)refreshHeaderWithBlock:(void(^)(void))block {
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i= 1 ; i < 75 ; i ++ ) {
        
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"图层%zd",i]]];
        
    }
    // 设置普通状态的动画图片
    [header setImages:images duration:2 forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:images duration:2 forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:images duration:2 forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    return header;
}

+ (MBProgressHUD *)showJiaHUDToView:(UIView *)view string:(NSString *)text {
    
    MBProgressHUD *HUD = [self showProgressHUDtoView:view];
//    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
//    HUD.contentColor = [UIColor whiteColor];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.detailsLabel.text = text;
//        UIImageView *img = [[UIImageView alloc] init];
//        img.image = [UIImage imageNamed:@"ds_ok"];
//        HUD.customView = img;
//        HUD.tintColor = [UIColor blackColor];
//        HUD.animationType = MBProgressHUDAnimationZoom;
//        [HUD hideAnimated:YES afterDelay:0.4];
//    });
    
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.removeFromSuperViewOnHide = YES;
    //    HUD.contentColor = kMainRedColor;
    //    #881FD9 100%
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    HUD.bezelView.backgroundColor = [UIColor colorWithRed:247/255.f green:47/255.f blue:94/255.f alpha:0.7];
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    YYAnimatedImageView *img = [[YYAnimatedImageView alloc] init];
    img.autoPlayAnimatedImage = YES;

    img.image = [YYImage imageNamed:@"loading"];
    HUD.customView = img;
    
    HUD.minSize = CGSizeMake(80, 80);
    
    return HUD;
    
}


+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)timeStringWithTime:(Float64)time {
    
    NSInteger currentSec = (NSInteger)time % 60;
    NSInteger currentMin = (NSInteger)time / 60;
    
    NSString *secString = currentSec <= 9 ? [NSString stringWithFormat:@"0%zd",currentSec]:[NSString stringWithFormat:@"%zd",currentSec];
    NSString *minString = currentMin <= 9 ? [NSString stringWithFormat:@"0%zd",currentMin]:[NSString stringWithFormat:@"%zd",currentMin];
    
    return [NSString stringWithFormat:@"%@:%@",minString,secString];
    
}

#pragma mark - 计算星座
+ (NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    
    NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    
    return result;
    
}

+ (MBProgressHUD *)showProgressHUDtoView:(UIView *)view withText:(NSString *)text {
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
//
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.removeFromSuperViewOnHide = YES;
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    //    HUD.contentColor = [UIColor whiteColor];
//    HUD.progress = 0.9;
//    //    HUD.dimBackground = YES;
//    HUD.animationType = MBProgressHUDAnimationZoom;
//    HUD.minShowTime = 0.3;
//    HUD.removeFromSuperViewOnHide = YES;
//    //    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
//    //    [HUD show:YES];
//    HUD.contentColor = [UIColor whiteColor];
//
//    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    HUD.bezelView.backgroundColor = [UIColor blackColor];
//    [HUD hideAnimated:YES afterDelay:0.7];
    
//    HUD.label.text = text;
    
    //    HUD.contentColor = kMainRedColor;
    //    #881FD9 100%
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    HUD.bezelView.backgroundColor = [UIColor colorWithRed:247/255.f green:47/255.f blue:94/255.f alpha:0.7];
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    //    HUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)kMainRedColor.CGColor];
    //    gradientLayer.locations = @[@0, @0.7];
    //    gradientLayer.startPoint = CGPointMake(0.3, 0);
    //    gradientLayer.endPoint = CGPointMake(1, 0.3);
    //
    //    gradientLayer.frame = CGRectMake(0, 0, 100, 100);
    //
    //    [HUD.bezelView.layer insertSublayer:gradientLayer atIndex:0];
    YYAnimatedImageView *img = [[YYAnimatedImageView alloc] init];
    img.autoPlayAnimatedImage = YES;
    img.image = [YYImage imageNamed:@"loading"];


    HUD.customView = img;


    return HUD;
}


/**
 展示菊花
 
 @param view 展示的view
 @return 菊花
 */
+ (MBProgressHUD *)showProgressHUDtoView:(UIView *)view {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.removeFromSuperViewOnHide = YES;
//    HUD.contentColor = kMainRedColor;
//    #881FD9 100%
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    HUD.bezelView.backgroundColor = [UIColor colorWithRed:247/255.f green:47/255.f blue:94/255.f alpha:0.7];
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];

    YYAnimatedImageView *img = [[YYAnimatedImageView alloc] init];
    img.autoPlayAnimatedImage = YES;
    img.image = [YYImage imageNamed:@"loading"];
    HUD.customView = img;
    img.contentMode = UIViewContentModeScaleAspectFit;
    HUD.minSize = CGSizeMake(80, 80);
    
    return HUD;
    
}

/**
 更改菊花称为文字
 
 @param HUD 菊花
 @param text 文字
 */
+ (void)changeHUD:(MBProgressHUD *)HUD successWithText:(NSString *)text {
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.detailsLabel.text = text;
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"ds_ok"];
    HUD.customView = img;
    HUD.tintColor = [UIColor blackColor];
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    HUD.contentColor = [UIColor whiteColor];
//    HUD.mode = MBProgressHUDModeText;
//    HUD.label.text = text;
    [HUD hideAnimated:YES afterDelay:0.5];
    
    
    
}

+ (CGFloat)getHeightFortext:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    
    CGRect frame = [text boundingRectWithSize:(CGSizeMake(width, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];

    return frame.size.height;
}

+ (UIActivityIndicatorView *)showIndicatorViewTo:(UIView *)view {
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    
    indicatorView.center = CGPointMake(kScreenWidth/2, (kScreenHeight - 64 - 49)/2);
    
    [view addSubview:indicatorView];
    indicatorView.color = kMainRedColor;
    [indicatorView startAnimating];
    
    return indicatorView;
    
}

+ (void)popanimationForLikeNode:(CALayer *)layer complate:(completeBlock)completeHandle {

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    animation.toValue = [NSValue valueWithCGPoint:(CGPointMake(0.75, 0.75))];
    
    animation.duration = 0.1;
    
    
    POPSpringAnimation *animation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    animation2.toValue = [NSValue valueWithCGPoint:(CGPointMake(1, 1))];
    
    animation2.springSpeed = 0;
    animation2.springBounciness = 18;

    animation2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        completeHandle();
    };
    
    [layer pop_addAnimation:animation forKey:@""];
    
    
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [layer pop_addAnimation:animation2 forKey:@""];
        
        
    };
    
}

+ (void)setTopCornerwith:(CGFloat)cornerRadius view:(UIView *)view {
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

+ (UIImage *)changeImageToWidth:(CGFloat)width image:(UIImage *)image {
    
    CGSize imageSize = image.size;
    
    CGFloat height = imageSize.height/imageSize.width * width;
    
    CGSize size = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
    
}

+ (CGFloat)getWidthForString:(NSString *)text forFont:(UIFont *)font {
    
    CGRect rect =[text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
    
    return rect.size.width;
}


+ (void)showProgressInWindowWithString:(NSString *)string {

    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    HUD.mode = MBProgressHUDModeText;
    
    HUD.detailsLabel.text = string;
    HUD.contentColor = [UIColor whiteColor];

    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    [HUD hideAnimated:YES afterDelay:0.7];

}

+(NSString *)ret32bitString

{
    
    char data[12];
    
    for (int x=0;x<12;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:12 encoding:NSUTF8StringEncoding];
    
}

+ (NSString *) md5:(NSString *)input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}



//sha1加密方式
+ (NSString *) sha1:(NSString *)input
{
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;

}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|7[1-35-8]|8[0-9]|70)\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
    
}


+ (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/**
 *  计算label的文字行数
 *
 *  @param label 需要计算的label
 *
 *  @return 每一行的内容集合
 */
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}


//倒计时
+ (void)countdownbutton:(UIButton *)countButton {
    
    __block NSInteger timeOut = 59;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _Timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //每秒执行一次
    
    dispatch_source_set_timer(_Timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_Timer, ^{
        
        if (timeOut <= 0) {
            
            //如果倒计时结束，则关闭
            
            dispatch_source_cancel(_Timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //倒计时结束，关闭之后进行的操作。
                
                [countButton setTitleColor:kMainRedColor forState:UIControlStateNormal];
                
                countButton.layer.borderColor = kMainRedColor.CGColor;
                [countButton setTitle:@"重新发送" forState:UIControlStateNormal];
                
                countButton.userInteractionEnabled = YES;
                
            });
            
        } else {
            
            int allTime = (int)60 + 1;
            
            int seconds = timeOut % allTime;
            
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d",seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //倒计时进行中进行的操作
                [countButton setTitleColor:UIColorHex(cccccc) forState:UIControlStateNormal];
                
                countButton.layer.borderColor = (__bridge CGColorRef _Nullable)(UIColorHex(cccccc));
                
                [countButton setTitle:[NSString stringWithFormat:@"%@S后重新获取",timeStr] forState:UIControlStateNormal];
                
                countButton.userInteractionEnabled = NO;
                
            });
            
            timeOut--;
            
        }
        
    });
    
    dispatch_resume(_Timer);
    
}

+ (UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

+ (void)addVideoToAlbumWithVideoPath:(NSString *)videoPath {
    
    
    
    
}

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}


+ (UIImage *)filterImageWith:(UIImage *)image {
//    /*..CoreImage中的模糊效果滤镜..*/
//    //CIImage,相当于UIImage,作用为获取图片资源
//    CIImage * ciImage = [[CIImage alloc]initWithImage:image];
//    //CIFilter,高斯模糊滤镜
//    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    //将图片输入到滤镜中
//    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
//    //用来查询滤镜可以设置的参数以及一些相关的信息
//    NSLog(@"%@",[blurFilter attributes]);
//    //设置模糊程度,默认为10,取值范围(0-100)
//    [blurFilter setValue:@(20) forKey:@"inputRadius"];
//    //将处理好的图片输出
//    CIImage * outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
//    //CIContext
//    CIContext * context = [CIContext contextWithOptions:nil];
//    //获取CGImage句柄,也就是从数据流中取出图片
//    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
//    //最终获取到图片
//    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
//    //释放CGImage句柄
//    CGImageRelease(outCGImage);
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(30) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
//    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    
    CGImageRef outImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;

    
//    return blurImage;
    
}


+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path {
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}


+ (NSString *)changeDateToStringWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];

    NSInteger year = dateCom.year;
    NSInteger month = dateCom.month;
    NSInteger day = dateCom.day;
    NSInteger hour = dateCom.hour;
    NSInteger minute = dateCom.minute;
    
    if (year > 0) {
        
        return [NSString stringWithFormat:@"%zd年之前",year];
        
    } else if (month > 0) {
        
        return [NSString stringWithFormat:@"%zd月之前",month];
    } else if (day > 0) {
        
        return [NSString stringWithFormat:@"%zd天之前",day];
    } else if (hour > 0) {
        
        return [NSString stringWithFormat:@"%zd小时之前",hour];

    } else if (minute > 1) {
        
        return [NSString stringWithFormat:@"%zd分钟之前",minute];
    } else {
        
        return @"刚刚";
    }

}

@end
