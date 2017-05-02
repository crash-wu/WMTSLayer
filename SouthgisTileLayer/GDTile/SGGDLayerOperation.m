//
//  Southgis_BdWMTSLayerOperation.m
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SGGDLayerOperation.h"

@implementation SGGDLayerOperation



- (instancetype)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(SouthgisTdt_LayerInfo *)layerInfo target:(id)target action:(SEL)action{
    
    if (self = [super init]) {
        self.target = target;
        self.action = action;
        self.tileKey = tileKey;
        self.layerInfo = layerInfo;
        
    }
    return self;
}

-(void)main {
    //Fetch the tile for the requested Level, Row, Column
    @try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }

        
        NSInteger num = (self.tileKey.column )% 4 + 1;
        
        NSString *baseUrl=[NSString stringWithFormat:@"http://webst0%ld.is.autonavi.com/appmaptile?style=7&x=%ld&y=%ld&z=%ld",num,self.tileKey.column,self.tileKey.row,self.tileKey.level];

//        http://webst01.is.autonavi.com/appmaptile?style=6&x=13417&y=6499&z=14
        
        NSURL* aURL = [NSURL URLWithString:baseUrl];
        self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
    }
    @finally {
        //Invoke the layer's action method
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
    
}





@end
