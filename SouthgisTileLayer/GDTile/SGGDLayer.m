//
//  SouthgisBdWMTSLayer.m
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//


#import "SGGDLayer.h"
#import "SGGDLayerOperation.h"
#import "SGGDLayerInfoDelegate.h"


@implementation SGGDLayer



/**
 *  @author crash         crash_wu@163.com   , 16-04-27 09:04:06
 *
 *  @brief  初始化百度地图
 *
 *  @param wmtsLayerType 百度地图类型
 *  @param outError      错误状态
 *
 *  @return 返回百度地图图层
 */
-(instancetype)initWithLayerType:(NSError *__autoreleasing *)outError{
    
    if (self = [super initWithCachePath:[self retFilePath]]) {
        
        /*get the currect layer info
         */
        _layerInfo = [[SGGDLayerInfoDelegate alloc]getLayerInfo];

        
        AGSSpatialReference* sr = [AGSSpatialReference spatialReferenceWithWKID:_layerInfo.srid];
        
        _fullEnvelope = [[AGSEnvelope alloc] initWithXmin:_layerInfo.xMin
                                                     ymin:_layerInfo.yMin
                                                     xmax:_layerInfo.xMax
                                                     ymax:_layerInfo.yMax
                                         spatialReference:sr];
        
        _tileInfo = [[AGSTileInfo alloc]initWithDpi:_layerInfo.dpi
                                             format:@"PNG" lods:_layerInfo.lods origin:_layerInfo.origin spatialReference:self.spatialReference tileSize:CGSizeMake(_layerInfo.tileWidth,_layerInfo.tileHeight)];
        
        [_tileInfo computeTileBounds:_fullEnvelope];
        
        [super layerDidLoad];
    }
    
    return self;
}




- (void)requestTileForKey:(AGSTileKey *)key{
    
    
    __weak typeof(self) weakSelf = self;
    
    [self loadTileDataFromCacheWithTileKey:key loadCompleteBlock:^(NSData *data) {
        
        if (data) {
            
            [weakSelf setTileData:data forKey:key];
            
        }
        else{
            SGGDLayerOperation *operation = [[SGGDLayerOperation alloc]initWithTileKey:key TiledLayerInfo:_layerInfo target:weakSelf action:@selector(didFinishOperation:)];
            
            [_requestQueue addOperation:operation];
        }
    }];
    
    
    
}

- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the Southigs_TiledServiceLayerOperation object for this key and cancel it
    for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[SGGDLayerOperation class]]){
            SGGDLayerOperation* offOp = (SGGDLayerOperation*)op;
            if([offOp.tileKey isEqualToTileKey:key]){
                [offOp cancel];
            }
        }
    }
}

- (void) didFinishOperation:(SGGDLayerOperation*)op{
    
    [super setTileData:op.imageData forKey:op.tileKey];
    
    
}



/**
 * @author Jeremy, 16-03-10 11:03:44
 *
 * 返回缓存路径
 *
 * @param tileKey
 *
 * @return 路径
 */
- (NSString *)retFilePath{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    
    NSString *docPath = [documentPaths objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/gd_wmts_tiles", docPath];
    
    
    return createPath;
}




@end
