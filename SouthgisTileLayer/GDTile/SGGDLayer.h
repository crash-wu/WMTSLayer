//
//  SouthgisBdWMTSLayer.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//


#import "SouthgisBaseTiledServiceLayer.h"


@class SouthgisTdt_LayerInfo;



@interface SGGDLayer : SouthgisBaseTiledServiceLayer{
    
@protected
    //图层信息
    SouthgisTdt_LayerInfo* _layerInfo;
}



/**
 *  @author crash         crash_wu@163.com   , 16-03-31 09:03:55
 *
 *  @brief  初始化百度WMTS图层
 *
 *  @param wmtsLayerType 切片类型
 *  @param outError     错误信息
 *
 *  @return 百度WMTS图层
 */
-(id)initWithLayerType:(NSError**) outError;



@end
