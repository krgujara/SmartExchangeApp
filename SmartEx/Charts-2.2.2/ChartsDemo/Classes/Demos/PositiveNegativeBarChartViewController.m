//
//  PositiveNegativeBarChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 08/02/2016.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "PositiveNegativeBarChartViewController.h"
#import "ChartsDemo-Swift.h"

@interface PositiveNegativeBarChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet BarChartView *chartView;

@end

@implementation PositiveNegativeBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Bar Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleHighlightArrow", @"label": @"Toggle Highlight Arrow"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    [self setupBarLineChartView:_chartView];
    
    _chartView.delegate = self;
    
    _chartView.extraTopOffset = -30.f;
    _chartView.extraBottomOffset = 10.f;
    _chartView.extraLeftOffset = 70.f;
    _chartView.extraRightOffset = 70.f;
    
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.descriptionText = @"";
    
    // scaling can now only be done on x- and y-axis separately
    _chartView.pinchZoomEnabled = NO;
    
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:13.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled = NO;
    xAxis.spaceBetweenLabels = 2.0;
    xAxis.labelTextColor = [UIColor lightGrayColor];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawLabelsEnabled = NO;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.spaceTop = 0.25f;
    leftAxis.spaceBottom = 0.25f;
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.drawGridLinesEnabled = NO;
    
    _chartView.rightAxis.enabled = NO;
    _chartView.legend.enabled = NO;
    
    // THIS IS THE ORIGINAL DATA YOU WANT TO PLOT
    NSArray<NSDictionary *> *data = @[
                                      @{@"xIndex": @(0),
                                        @"yValue": @(-224.1f),
                                        @"xValue": @"12-19"},
                                      @{@"xIndex": @(1),
                                        @"yValue": @(238.5f),
                                        @"xValue": @"12-30"},
                                      @{@"xIndex": @(2),
                                        @"yValue": @(1280.1f),
                                        @"xValue": @"12-31"},
                                      @{@"xIndex": @(3),
                                        @"yValue": @(-442.3f),
                                        @"xValue": @"01-01"},
                                      @{@"xIndex": @(4),
                                        @"yValue": @(-2280.1f),
                                        @"xValue": @"01-02"},
                                      ];

    [self setData:data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(NSArray<NSDictionary *> *)dataList
{
    NSMutableArray<BarChartDataEntry *> *values = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *dates = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] init];
    
    UIColor *green = [UIColor colorWithRed:110/255.f green:190/255.f blue:102/255.f alpha:1.f];
    UIColor *red = [UIColor colorWithRed:211/255.f green:74/255.f blue:88/255.f alpha:1.f];
    
    for (int i = 0; i < dataList.count; i++)
    {
        NSDictionary *d = dataList[i];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithValue:[d[@"yValue"] doubleValue] xIndex:[d[@"xIndex"] integerValue]];
        [values addObject:entry];
        
        [dates addObject:d[@"xValue"]];
        
        // specific colors
        if ([d[@"yValue"] doubleValue] >= 0.f)
        {
            [colors addObject:red];
        }
        else
        {
            [colors addObject:green];
        }
    }
    
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:values label:@"Values"];
    set.barSpace = 0.4f;
    set.colors = colors;
    set.valueColors = colors;
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:dates dataSet:set];
    [data setValueFont:[UIFont systemFontOfSize:13.f]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    [data setValueFormatter:formatter];
    
    _chartView.data = data;
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlightArrow"])
    {
        _chartView.drawHighlightArrowEnabled = !_chartView.isDrawHighlightArrowEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
