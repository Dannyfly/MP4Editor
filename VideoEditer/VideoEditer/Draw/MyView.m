//
//  MyView.m
//  DrawWall
//
//  Created by gll on 13-1-2.
//  Copyright (c) 2013年 gll. All rights reserved.
//

#import "MyView.h"

@implementation MyView
//保存线条颜色
static NSMutableArray *colorArray;
//保存被移除的线条颜色
static NSMutableArray *deleColorArray;
//每次触摸结束前经过的点，形成线的点数组
static NSMutableArray *pointArray;
//每次触摸结束后的线数组
static NSMutableArray *lineArray;
//删除的线的数组，方便重做时取出来
static NSMutableArray *deleArray;
//线条宽度的数组
static float lineWidthArray[4]={10.0,20.0,30.0,40.0};
//删除线条时删除的线条宽度储存的数组
static NSMutableArray *deleWidthArray;
//正常存储的线条宽度的数组
static NSMutableArray *WidthArray;
//确定颜色的值，将颜色计数的值存到数组里默认为0，即为绿色
static int colorCount;
//确定宽度的值，将宽度计数的值存到数组里默认为0，即为10
static int widthCount;
//保存颜色的数组
static NSMutableArray *colors;
- (id)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化颜色数组，将用到的颜色存储到数组里
        colors=[[NSMutableArray alloc]initWithObjects:[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
        WidthArray=[[NSMutableArray alloc]init];
        deleWidthArray=[[NSMutableArray alloc]init];
        pointArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        deleArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        deleColorArray=[[NSMutableArray alloc]init];
        //颜色和宽度默认都取当前数组第0位为默认值
        colorCount=0;
        widthCount=0;
        // Initialization code
    }
    return self;
}
//给界面按钮操作时获取tag值作为width的计数。来确定宽度，颜色同理
-(void)setlineWidth:(NSInteger)width{
    widthCount=width;
}
-(void)setLineColor:(NSInteger)color{
    colorCount=color;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//uiview默认的drawRect方法，覆盖重写，可在界面上重绘，并将AViewController.xib的文件设置为自定义的MyView
- (void)drawRect:(CGRect)rect
{
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
//    CGContextSetLineCap(context, kCGLineJoinRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count]>0) {
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
           
        if ([array count]>0)
        {
            CGContextBeginPath(context);
            CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
            CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
            
            for (int j=0; j<[array count]-1; j++)
            {
                CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                //--------------------------------------------------------
                CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
            }
            //获取colorArray数组里的要绘制线条的颜色
            NSNumber *num=[colorArray objectAtIndex:i];
            int count=[num intValue];
            UIColor *lineColor=[colors objectAtIndex:count];
            //获取WidthArray数组里的要绘制线条的宽度
            NSNumber *wid=[WidthArray objectAtIndex:i];
            int widthc=[wid intValue];
            float width=lineWidthArray[widthc];
            //设置线条的颜色，要取uicolor的CGColor
            CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
            //-------------------------------------------------------
            //设置线条宽度
            CGContextSetLineWidth(context, width);
            //保存自己画的
            CGContextStrokePath(context);
        }
     }
    }
    //画当前的线
    if ([pointArray count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        UIColor *lineColor=[colors objectAtIndex:colorCount];
        float width=lineWidthArray[widthCount];
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        //-------------------------------------------------------
        CGContextSetLineWidth(context, width);
        CGContextStrokePath(context);
    }

     
}
//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [pointArray addObject:sPoint];
}
//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInt:widthCount];
    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
    [colorArray addObject:num];
    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    pointArray=[[NSMutableArray alloc]init];
}

#pragma mark -
//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self addLA];
//    NSArray *array=[NSArray arrayWithArray:pointArray];
//    [lineArray addObject:array];
//    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
//    [colorArray addObject:num];
//    pointArray=[[NSMutableArray alloc]init];
    NSLog(@"touches end");
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches Canelled");
}
//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
-(void)revocation{
    if ([lineArray count]) {
        [deleArray addObject:[lineArray lastObject]];
        [lineArray removeLastObject];
    }
    if ([colorArray count]) {
        [deleColorArray addObject:[colorArray lastObject]];
        [colorArray removeLastObject];
    }
    if ([WidthArray count]) {
        [deleWidthArray addObject:[WidthArray lastObject]];
        [WidthArray removeLastObject];
    }
    //界面重绘方法
    [self setNeedsDisplay];
}
//将删除线条数组里的信息，移动到当前数组，在主界面重绘
-(void)refrom{
    if ([deleArray count]) {
        [lineArray addObject:[deleArray lastObject]];
        [deleArray removeLastObject];
    }
    if ([deleColorArray count]) {
        [colorArray addObject:[deleColorArray lastObject]];
        [deleColorArray removeLastObject];
    }
    if ([deleWidthArray count]) {
        [WidthArray addObject:[deleWidthArray lastObject]];
        [deleWidthArray removeLastObject];
    }
    [self setNeedsDisplay];
     
}
-(void)clear{
    //移除所有信息并重绘
   [deleArray removeAllObjects];
    [deleColorArray removeAllObjects];
    colorCount=0;
    [colorArray removeAllObjects];
    [lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [deleWidthArray removeAllObjects];
    widthCount=0;
    [WidthArray removeAllObjects];
    [self setNeedsDisplay];
    //清屏以后可以重绘，有些问题
    //    deleColorArray=[[NSMutableArray alloc]init];
    //    deleArray=[[NSMutableArray alloc]init];
    //    deleArray =[NSMutableArray arrayWithArray:lineArray];
    //    deleColorArray =[NSMutableArray arrayWithArray:colorArray];
}
@end
