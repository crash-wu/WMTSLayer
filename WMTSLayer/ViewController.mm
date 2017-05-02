//
//  ViewController.m
//  WMTSLayer
//
//  Created by 吴小星 on 16/6/1.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "ViewController.h"

#import "SGSWMTSLayer.h"
#import "SGSWMTSInfo.h"
#import "SGSWMTSLayerInfo.h"
#import "Southgis_TiledServiceLayer.h"
#import "SouthgisTdtType.h"
#import "SouthgisTdt_TileLayer.h"
#import "SGGDLayer.h"


@interface ViewController ()<AGSMapViewLayerDelegate,SGSWMTSInfoDelegate>



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView =  [[AGSMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //[self loadTdtTileLayer:WMTS_TERRAIN_MERCATOR andMapView:self.mapView];
    [self loadGDTile:self.mapView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadGDTile:(nonnull AGSMapView * ) mapView{
        NSError *error;
    
    SGGDLayer *layer = [[SGGDLayer alloc] initWithLayerType:&error];
    [mapView addMapLayer:layer withName:@"tiandity_layer"];
}

/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:49
 *
 *  @brief  加载天地图
 *
 *  @param tdtLayerType 天地图瓦片类型
 
 *  @param mapView      地图容器
 */
-(void)loadTdtTileLayer:(WMTSLayerTypes) tdtLayerType  andMapView :(nonnull AGSMapView * ) mapView{
    
    
    [mapView removeMapLayerWithName:@"tiandity_layer"];
    [mapView removeMapLayerWithName:@"tiandity_layer_annotation"];
    NSError *error;
    
    SouthgisTdt_TileLayer *layer = [[SouthgisTdt_TileLayer alloc]initWithLayerType:tdtLayerType error:&error];
    
    if(layer != nil){
        
        [mapView addMapLayer:layer withName:@"tiandity_layer"];
        
    }
    
    WMTSLayerTypes  annotation = WMTS_VECTOR_ANNOTATION_CHINESE_2000 ;
    
    switch (tdtLayerType) {
        case WMTS_VECTOR_MERCATOR://天地图矢量墨卡托投影地图服务
            annotation=WMTS_VECTOR_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图矢量墨卡托中文标注 */
            break;
            
        case WMTS_IMAGE_MERCATOR://天地图影像墨卡托投影地图服务
            annotation=WMTS_IMAGE_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图影像墨卡托投影中文标注 */
            break;
            
        case WMTS_TERRAIN_MERCATOR://天地图地形墨卡托投影地图服务
            annotation=WMTS_TERRAIN_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图地形墨卡托投影中文标注 */
            break;
            
        case WMTS_VECTOR_2000://天地图矢量国家2000坐标系地图服务
            /*!< 天地图矢量国家2000坐标系中文标注 */
            annotation=WMTS_VECTOR_ANNOTATION_CHINESE_2000;
            
            break;
            
        case WMTS_IMAGE_2000://天地图影像国家2000坐标系地图服务
            /*!< 天地图影像国家2000坐标系中文标注 */
            annotation=WMTS_IMAGE_ANNOTATION_CHINESE_2000;
            
            break;
            
        case WMTS_TERRAIN_2000:
            /*!< 天地图地形国家2000坐标系中文标注 */
            annotation=WMTS_TERRAIN_ANNOTATION_CHINESE_2000;
            
            break;
        default:
            break;
            
    }
    
    SouthgisTdt_TileLayer *annotationLayer = [[SouthgisTdt_TileLayer alloc]initWithLayerType:annotation error:&error];
    if (annotationLayer != nil){
        
        [mapView addMapLayer:annotationLayer withName:@"tiandity_layer_annotation"];
    }
    
    //设置地图环绕
    [mapView enableWrapAround];
    
}



@end

