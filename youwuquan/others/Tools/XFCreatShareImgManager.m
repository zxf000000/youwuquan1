//
//  XFCreatShareImgManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCreatShareImgManager.h"
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>

@implementation XFCreatShareImgManager
// 生成二维码
+ (UIImage *)creatQRcodeWithInfo:(NSString *)path withSize:(CGSize)imageSize {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [path dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [UIImage imageWithCIImage:outPutImage];

}


+ (UIImage *)shareurlImgWithBgImage:(UIImage *)bgImage iconImage:(UIImage *)iconImage url:(NSString *)url {

    CGSize size = CGSizeMake(375 , 580);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, size.width, size.height))];
    whiteView.backgroundColor = [UIColor colorWithRed:136/255.f green:31/255.f blue:217/255.f alpha:1];
    [whiteView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 最底层背景
    [iconImage drawInRect:CGRectMake(0, 0, size.width , size.height ) withContentMode:(UIViewContentModeScaleAspectFit) clipsToBounds:NO];
    // 绘制背景图
    [bgImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 二维码
    UIImage *QRCodeImg = [self creatQRcodeWithInfo:url withSize:(CGSizeMake(69, 69))];
    
    [QRCodeImg drawInRect:(CGRectMake(17, 459, 69, 69))];
    
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    
    return resultingImage;
    
}


+ (UIImage *)shareImgWithBgImage:(UIImage *)bgImage iconImage:(UIImage *)iconImage name:(NSString *)name userId:(NSString *)userId address:(NSString *)address {

    CGSize size = CGSizeMake(375 , 580);
    
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);

    // Heiti SC
    
    // 模糊头像作为最底层背景
    UIImage *blurImg = [self boxblurImage:iconImage withBlurNumber:10];
    
    [blurImg drawInRect:CGRectMake(0, 0, size.width , size.height ) withContentMode:(UIViewContentModeScaleToFill) clipsToBounds:NO];
    // 绘制背景图
    [bgImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 绘制头像
    UIImage *icon = [self drawCircleImageForImage:iconImage];
    
    UIImage *dinalIcon = [icon imageByRoundCornerRadius:107 borderWidth:4 borderColor:[UIColor blackColor]];;
    
    [dinalIcon drawInRect:CGRectMake(80, 86, 215, 215)];

    // 绘制名字Id地址
    NSDictionary *nameAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]};
    
    CGRect nameFrame = [name boundingRectWithSize:(CGSizeMake(MAXFLOAT, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:nameAttr context:nil];
    CGFloat nameWidth = nameFrame.size.width;
    CGFloat nameHeight = nameFrame.size.height;
    [name drawInRect:(CGRectMake((375 - nameWidth)/2, 370, nameWidth, nameHeight)) withAttributes:nameAttr];
    
//    [name drawAtPoint:(CGPointMake(375/2.f, 370)) withAttributes:nameAttr];
    NSDictionary *idAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor blackColor]};
    CGRect idFrame = [userId boundingRectWithSize:(CGSizeMake(MAXFLOAT, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:nameAttr context:nil];
    CGFloat idWidth = idFrame.size.width;
    CGFloat idHeight = idFrame.size.height;
        idWidth = [userId sizeWithAttributes:idAttr].width;
    [userId drawInRect:(CGRectMake((375 - idWidth)/2, 400, idWidth, idHeight)) withAttributes:idAttr];
    
    NSDictionary *addAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor blackColor]};
    CGRect addFrame = [address boundingRectWithSize:(CGSizeMake(MAXFLOAT, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:addAttr context:nil];
    CGFloat addWidth = addFrame.size.width;
    CGFloat addHeight = addFrame.size.height;
    addWidth = [address sizeWithAttributes:addAttr].width;

    [address drawInRect:(CGRectMake((375 - addWidth)/2, 425, addWidth, addHeight)) withAttributes:idAttr];
    
    // 二维码
    UIImage *QRCodeImg = [self creatQRcodeWithInfo:@"http://www.baidu.com" withSize:(CGSizeMake(69, 69))];
    
    [QRCodeImg drawInRect:(CGRectMake(17, 459, 69, 69))];
    
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    
    return resultingImage;

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
    /*..CoreImage中的模糊效果滤镜..*/
    //CIImage,相当于UIImage,作用为获取图片资源
    CIImage * ciImage = [[CIImage alloc]initWithImage:image];
    //CIFilter,高斯模糊滤镜
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //将图片输入到滤镜中
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    //用来查询滤镜可以设置的参数以及一些相关的信息
    NSLog(@"%@",[blurFilter attributes]);
    //设置模糊程度,默认为10,取值范围(0-100)
    [blurFilter setValue:@(10) forKey:@"inputRadius"];
    //将处理好的图片输出
    CIImage * outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    //CIContext
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取CGImage句柄,也就是从数据流中取出图片
    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
    //最终获取到图片
    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
    //释放CGImage句柄
    CGImageRelease(outCGImage);

    return blurImage;
    
}

+ (UIImage *)drawCircleImageForImage:(UIImage *)image {
    
    UIImage *littleImg = [XFToolManager imageWithImage:image scaledToSize:(CGSizeMake(215, 215))];
    
    // 更改image
    CGFloat side = MIN(littleImg.size.width, littleImg.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), YES, 0);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat marginX = -(littleImg.size.width - side) / 2.f;
    CGFloat marginY = -(littleImg.size.height - side) / 2.f;
    [littleImg drawInRect:CGRectMake(marginX, marginY, littleImg.size.width, littleImg.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)shotImage {
    
//    CGRect imageRect;
//
//    // 截屏
//    // 开启上下文
//
//    //
//
//    //    self.imageView.imageView.hidden = YES;
//
//    //
//
//    //    self.imageView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
//
//    CGFloat scale = [[UIScreen mainScreen] scale];
//
//    CGSize imageSize = CGSizeMake(imageRect.size.width*scale, imageRect.size.height*scale);
//
//    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
//
//    // 获取上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    // 渲染图层
//
//    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
//                                    [self methodSignatureForSelector:
//                                     @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
//        [invocation setTarget:self];
//        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
//        CGRect arg2 = self.imageView.bounds;
//        BOOL arg3 = YES;
//        [invocation setArgument:&arg2 atIndex:2];
//        [invocation setArgument:&arg3 atIndex:3];
//        [invocation invoke];
//    } else { // IOS7之前的版本
//        [self.imageView.layer renderInContext:ctx];
//    }
//    // 获取上下文中的图片
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//
//    //将UIImage转换成CGImageRef
//    CGImageRef sourceImageRef = [image CGImage];
//
//    //按照给定的矩形区域进行剪裁
//
//    CGRect frame = imageRect;
//
//    CGFloat x = frame.origin.x * scale;
//
//    CGFloat y = frame.origin.y * scale;
//
//    CGFloat width = frame.size.width * scale;
//
//    CGFloat height = frame.size.height * scale;
//
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(x, y, width, height));
//
//
//    //将CGImageRef转换成UIImagenewImageRef
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//
//    // 关闭上下文
//
//    UIGraphicsEndImageContext();

    
}

+ (int)getAttributedStringWidthWithString:(NSMutableAttributedString *)string
{
//    int total_height = 0;
    string.attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]};;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, 1000, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
//    int line_x = (int) origins[0].x;  //第一行line的原点x坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:0];
    double width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
//    total_height = 1000 - line_x + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return width;
    
}

@end
