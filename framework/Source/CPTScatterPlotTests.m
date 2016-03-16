#import "CPTScatterPlotTests.h"

#import "CPTPlotRange.h"
#import "CPTScatterPlot.h"
#import "CPTXYPlotSpace.h"

@interface CPTScatterPlot(Testing)

-(void)calculatePointsToDraw:(nonnull BOOL *)pointDrawFlags forPlotSpace:(nonnull CPTXYPlotSpace *)xyPlotSpace includeVisiblePointsOnly:(BOOL)visibleOnly numberOfPoints:(NSUInteger)dataCount;
-(void)setXValues:(nullable CPTNumberArray)newValues;
-(void)setYValues:(nullable CPTNumberArray)newValues;

@end

@implementation CPTScatterPlotTests

@synthesize plot;
@synthesize plotSpace;

-(void)setUp
{
    double values[5] = { 0.5, 0.5, 0.5, 0.5, 0.5 };

    self.plot = [CPTScatterPlot new];
    CPTMutableNumberArray yValues = [NSMutableArray array];
    for ( NSInteger i = 0; i < 5; i++ ) {
        [yValues addObject:@(values[i])];
    }
    [self.plot setYValues:yValues];
    self.plot.cachePrecision = CPTPlotCachePrecisionDouble;

    CPTPlotRange *xPlotRange = [CPTPlotRange plotRangeWithLocation:@0.0 length:@1.0];
    CPTPlotRange *yPlotRange = [CPTPlotRange plotRangeWithLocation:@0.0 length:@1.0];
    self.plotSpace        = [[CPTXYPlotSpace alloc] init];
    self.plotSpace.xRange = xPlotRange;
    self.plotSpace.yRange = yPlotRange;
}

-(void)tearDown
{
    self.plot      = nil;
    self.plotSpace = nil;
}

-(void)testCalculatePointsToDrawAllInRange
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { 0.1, 0.2, 0.15, 0.6, 0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:NO numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertTrue(drawFlags[i], @"Test that in range points are drawn (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawAllInRangeVisibleOnly
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { 0.1, 0.2, 0.15, 0.6, 0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:YES numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertTrue(drawFlags[i], @"Test that in range points are drawn (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawNoneInRange
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, -0.2, -0.15, -0.6, -0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:NO numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertFalse(drawFlags[i], @"Test that out of range points are not drawn (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawNoneInRangeVisibleOnly
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, -0.2, -0.15, -0.6, -0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:YES numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertFalse(drawFlags[i], @"Test that out of range points are not drawn (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawNoneInRangeDifferentRegions
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 2, -0.15, 3, -0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:NO numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertTrue(drawFlags[i], @"Test that out of range points in different regions get included (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawNoneInRangeDifferentRegionsVisibleOnly
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 2, -0.15, 3, -0.9 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:YES numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        XCTAssertFalse(drawFlags[i], @"Test that out of range points in different regions get included (%g).", inRangeValues[i]);
    }
}

-(void)testCalculatePointsToDrawSomeInRange
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 0.1, 0.2, 1.2, 1.5 };
    BOOL expected[5]        = { YES, YES, YES, YES, NO };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:NO numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        if ( expected[i] ) {
            XCTAssertTrue(drawFlags[i], @"Test that correct points included when some are in range, others out (%g).", inRangeValues[i]);
        }
        else {
            XCTAssertFalse(drawFlags[i], @"Test that correct points included when some are in range, others out (%g).", inRangeValues[i]);
        }
    }
}

-(void)testCalculatePointsToDrawSomeInRangeVisibleOnly
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 0.1, 0.2, 1.2, 1.5 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:YES numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        if ( [self.plotSpace.xRange compareToNumber:@(inRangeValues[i])] == CPTPlotRangeComparisonResultNumberInRange ) {
            XCTAssertTrue(drawFlags[i], @"Test that correct points included when some are in range, others out (%g).", inRangeValues[i]);
        }
        else {
            XCTAssertFalse(drawFlags[i], @"Test that correct points included when some are in range, others out (%g).", inRangeValues[i]);
        }
    }
}

-(void)testCalculatePointsToDrawSomeInRangeCrossing
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 1.1, 0.9, -0.1, -0.2 };
    BOOL expected[5]        = { YES, YES, YES, YES, NO };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:NO numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        if ( expected[i] ) {
            XCTAssertTrue(drawFlags[i], @"Test that correct points included when some are in range, others out, crossing range (%g).", inRangeValues[i]);
        }
        else {
            XCTAssertFalse(drawFlags[i], @"Test that correct points included when some are in range, others out, crossing range (%g).", inRangeValues[i]);
        }
    }
}

-(void)testCalculatePointsToDrawSomeInRangeCrossingVisibleOnly
{
    BOOL drawFlags[5];
    double inRangeValues[5] = { -0.1, 1.1, 0.9, -0.1, -0.2 };

    CPTMutableNumberArray values = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [values addObject:@(inRangeValues[i])];
    }

    CPTXYPlotSpace *thePlotSpace = self.plotSpace;

    [self.plot setXValues:values];
    [self.plot calculatePointsToDraw:drawFlags forPlotSpace:thePlotSpace includeVisiblePointsOnly:YES numberOfPoints:values.count];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        if ( [self.plotSpace.xRange compareToNumber:@(inRangeValues[i])] == CPTPlotRangeComparisonResultNumberInRange ) {
            XCTAssertTrue(drawFlags[i], @"Test that correct points included when some are in range, others out, crossing range (%g).", inRangeValues[i]);
        }
        else {
            XCTAssertFalse(drawFlags[i], @"Test that correct points included when some are in range, others out, crossing range (%g).", inRangeValues[i]);
        }
    }
}

@end
