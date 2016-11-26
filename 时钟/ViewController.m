//
//  ViewController.m
//  时钟
//
//  Created by 文锴 on 2016/11/11.
//  Copyright © 2016年 wkwk. All rights reserved.
//
#import "ViewController.h"
#define CLockViewSize self.clockView.frame.size
#define SizeH  self.view.frame.size.height
#define SizeW  self.view.frame.size.width
#define prensentS(x) (x*6*M_PI)/180
#define prensentH(x) ((x*30)* M_PI)/180
#define angle2radian(x) ((x) / 180.0 * M_PI)
@interface ViewController ()

{
    CALayer * _secondLayer;
    CALayer * _minuteLayer;
    CALayer * _hourLayer;
    
}
@property (nonatomic, assign) BOOL  ison;
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (nonatomic, weak) CALayer *heartLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem*item = [UITabBarItem appearance];
  
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIImageView  *viewI=[[UIImageView alloc] init];
//    [viewI setImage:[UIImage imageNamed:@"钟表"]];
//    viewI.bounds=self.clockView.bounds;
//    
//    [self.clockView addSubview:viewI];
   
    [self addbutton];
    
    //心跳代码
    [self addheartLayer];
    
    //时钟代码
    [self addsecond];
    [self addminute];
    [self addhour];
    [self addcenter];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [self updateTime];
   
}
-(void)addbutton{
    
    UIButton * button1=[self addbutonTitle:@"心跳" Color:[UIColor grayColor] type:butt1];
    
    UIButton * button2=[self addbutonTitle:@"抖动心" Color:[UIColor purpleColor] type:butt2];
    
    
    UIButton * button3=[self addbutonTitle:@"旋转心" Color:[UIColor blueColor] type:butt3];
    
    NSString * VflH=@"H:|-30-[button1(button2)]-40-[button2(button1)]-40-[button3(button2)]-30-|";
    //NSString * VflH=@"H:|-30-[button1(100)]";
  NSString * VflV=@"V:|-30-[button1(50)]";
    
    NSDictionary * viewsDict=NSDictionaryOfVariableBindings(button1,button2,button3);
    NSArray * array=[NSLayoutConstraint constraintsWithVisualFormat:VflH options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:nil views:viewsDict];
    NSArray * array1=[NSLayoutConstraint constraintsWithVisualFormat:VflV options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDict];
    [self.view addConstraints:array];
    [self.view addConstraints:array1];
}
-(UIButton*)addbutonTitle:(NSString*)title Color:(UIColor*)color type:(buttontype)type{
    
    UIButton * button3=[[UIButton alloc] init];
    [button3 setTitle:title forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button3.backgroundColor=color;
    button3.tag=type;
    button3.translatesAutoresizingMaskIntoConstraints = NO;
    [button3 addTarget:self action:@selector(buttonTopath:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    return button3;
}

-(void)buttonTopath:(UIButton* )button{
    buttontype type=(buttontype)button.tag;
    switch (type) {
        case butt1:{
            
        if ((button.selected=!button.selected)) {
             [self setAnimate];
            
           // [self resumeLayer:_heartLayer];
           
            }
            else{
               //[self pauseLayer:_heartLayer];
                [_heartLayer removeAnimationForKey:@"heart"];
               
            }
            break;}
        case butt3:
            if ((button.selected=!button.selected)) {
                [self resumeLayer:_heartLayer];
                if (!_ison) {
                    [self setMovePath];
                }
                
                _ison=YES;
                
               
            }
            else{
                [self pauseLayer:_heartLayer];
               // [_heartLayer removeAnimationForKey:@"Move"];
                
            }
            break;
        case butt2:
            if ((button.selected=!button.selected)) {
                [self setshake];
                //[self resumeLayer:_heartLayer];
             
            }
            else{
               // [self pauseLayer:_heartLayer];
                [_heartLayer removeAnimationForKey:@"shake"];
                
            }

            break;
        default:
            break;
    }
    //使用if 语句
//    if (button.tag) {
//          [self setAnimate];
//   }
//    else if (button.tag==11){
//        
//    }
}

-(void)addheartLayer{
    CALayer * heartlayer=[CALayer layer];
    heartlayer.position=CGPointMake(self.view.center.x, 180);
    heartlayer.backgroundColor=[UIColor clearColor].CGColor;
    heartlayer.bounds=CGRectMake(0, 0, 100, 100);
     UIImage * image=  [self  imageToTransparent:[UIImage imageNamed:@"心"]];
    
   
    heartlayer.contents=(__bridge id _Nullable)(image.CGImage);
    [self.view.layer addSublayer:heartlayer];
    _heartLayer=heartlayer;
    
    
}
//暂停动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
//恢复动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
-(void)setshake{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle2radian(-7)),@(angle2radian(7)),@(angle2radian(-7))];
    
    anim.repeatCount = MAXFLOAT;
    
    anim.duration = 0.2;
    
    [_heartLayer addAnimation:anim forKey:@"shake"];
    
}
-(void)setMovePath{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    // 设置动画属性
    anim.keyPath = @"position";
    
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((SizeW*0.5)-150, (SizeH*0.5)-150, 300, 300)];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SizeW*0.5, SizeH*0.5) radius:150.0f startAngle:-M_PI_2 endAngle:(M_PI*2-M_PI_2) clockwise:YES];
    
        //[path closePath];
    
    anim.path = path.CGPath;
    
    anim.duration = 2;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.calculationMode = kCAAnimationPaced;
    
    //旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
    anim.rotationMode = kCAAnimationRotateAuto;
    // 取消反弹
    anim.removedOnCompletion = NO;
    
    anim.fillMode = kCAFillModeForwards;
    
    anim.repeatCount = MAXFLOAT;
    
    [_heartLayer addAnimation:anim forKey:@"Move"];

}
//缩放核心动画
-(void)setAnimate{
    CABasicAnimation * basicAM=[CABasicAnimation animation];
    basicAM.keyPath=@"transform";
  basicAM.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1)];
    basicAM.removedOnCompletion=NO;
    basicAM.repeatCount=MAXFLOAT;
    basicAM.duration=0.5;
    basicAM.fillMode=kCAFillModeForwards;
    [_heartLayer addAnimation:basicAM forKey:@"heart"];
    
    
}
//加入中心点
-(void)addcenter{
    CALayer *center=[CALayer layer];
    center.backgroundColor=[UIColor blackColor].CGColor;
    center.bounds=CGRectMake(0, 0, 4, 4);
    center.cornerRadius=2;
    center.position=CGPointMake(100, 100);
    [self.clockView.layer addSublayer:center];
    
    
    
}
//更新时间
-(void)updateTime{
    NSCalendar * caledar=[NSCalendar currentCalendar];
   NSDateComponents * components= [caledar components:NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitSecond fromDate:[NSDate date]];
    CGFloat second=components.second;
    CGFloat minute=components.minute;
    
    CGFloat hour=components.hour;
    hour +=minute/60;
    _secondLayer.transform=CATransform3DMakeRotation(prensentS(second), 0, 0, 1);
    _minuteLayer.transform=CATransform3DMakeRotation(prensentS(minute), 0, 0, 1);
    _hourLayer.transform=CATransform3DMakeRotation(prensentH(hour), 0, 0, 1);
    
}
//加入秒钟
-(void)addsecond{
    CALayer * secondlayer=[CALayer layer];
    secondlayer.anchorPoint=CGPointMake(0.5, 1);
    secondlayer.position=CGPointMake(100, 100);
    secondlayer.bounds=CGRectMake(0, 0, 1,80 );
    
    secondlayer.cornerRadius=1;
    secondlayer.backgroundColor=[UIColor redColor].CGColor;
    _secondLayer=secondlayer;
    [self.clockView.layer addSublayer:secondlayer];
}
//加入分钟
-(void)addminute{
    CALayer * minutelayer=[CALayer layer];
    minutelayer.anchorPoint=CGPointMake(0.5, 1);
    minutelayer.position=CGPointMake(100, 100);
    minutelayer.bounds=CGRectMake(0, 0, 1.5,70 );
    minutelayer.cornerRadius=5;
    minutelayer.backgroundColor=[UIColor blueColor].CGColor;
    _minuteLayer=minutelayer;
    [self.clockView.layer addSublayer:minutelayer];
}
//加入小时
-(void)addhour{
    CALayer * hourlayer=[CALayer layer];
    hourlayer.anchorPoint=CGPointMake(0.5, 1);
    hourlayer.position=CGPointMake(100,100);
    hourlayer.bounds=CGRectMake(0, 0, 2,60 );
    hourlayer.cornerRadius=5;
    hourlayer.backgroundColor=[UIColor blackColor].CGColor;
    _hourLayer=hourlayer;
    [self.clockView.layer addSublayer:hourlayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//去除图片的白色背景

- (UIImage*) ImageToTransparent:(UIImage*) image
{
    
    // 分配内存
    
    const int imageWidth = image.size.width;
    
    const int imageHeight = image.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    
    // 创建context
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    
    
    // 遍历像素
    
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
        
    {
        
        //        //去除白色...将0xFFFFFF00换成其它颜色也可以替换其他颜色。
        
        //        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00) {
        
        //
        
        //            uint8_t* ptr = (uint8_t*)pCurPtr;
        
        //            ptr[0] = 0;
        
        //        }
        
        //接近白色
        
        //将像素点转成子节数组来表示---第一个表示透明度即ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B
        
        //分别取出RGB值后。进行判断需不需要设成透明。
        
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        if (ptr[1] > 240 && ptr[2] > 240 && ptr[3] > 240) {
            
            //当RGB值都大于240则比较接近白色的都将透明度设为0.-----即接近白色的都设置为透明。某些白色背景具有杂质就会去不干净，用这个方法可以去干净
            
            ptr[0] = 0;
            
        }
        
    }
    
    // 将内存转成image
    
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    
    
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true,kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
    
}


-(UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
            
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}


/** 颜色变化 */

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

@end
