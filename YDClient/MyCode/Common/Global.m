//
//  Global.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "Global.h"
#import "YDPathOverLay.h"


#define kCalloutViewMargin          -8


@interface Global ()<MAMapViewDelegate, AMapSearchDelegate, AMapNaviDriveManagerDelegate, AMapLocationManagerDelegate>

// 导航起始点
@property (nonatomic, strong) AMapNaviPoint *upPoint;
@property (nonatomic, strong) AMapNaviPoint *downPoint;
@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) MACircle *circle;

@end

@implementation Global

GPL_M_SINGLETON(Global);

- (instancetype)init{
    if (self = [super init]) {
        self.manager = [[YDSQLiteManager alloc] init];
        
        // 创建订单信息的数据库
        [self.manager createTableListWithDictionary:@[ORDER_ID, SERVICE_ID, UP_PLACE, UP_LAT, UP_LON, DOWN_PLACE, DOWN_LAT, DOWN_LON, PASSANGER_NAME, PASSANGER_PHONE, PREVIEW_TIME, PRICE, DRIVER_NAME] tableName:ORDER_TABLE];
        
        [self.manager createTableListWithDictionary:@[ADDRESS_NAME, ADDRESS_INFO, ADDRESS_LAT, ADDRESS_LON, CHOSE_TIMES] tableName:ADDRESS_TABLE];
        
    }
    return self;
}

#pragma mark ----------- 地图相关

- (void)searchPOIWithString:(NSString *)string {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = string;
    if (self.cityName.length > 0) {
        request.city = self.cityName;
    }

    request.requireExtension    = YES;
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

/** 逆地理编码 */
- (void)regeoWithLat:(float)lat lon:(float)lon{

    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

/** 驾车路线计算 */
- (void)calculateDistanceWithArray:(NSArray *)array{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    self.addressArray = array;
    [self clearAnnotions];
    [self addAnnotionsWithArray:self.addressArray];
    if (self.addressArray.count < 2) {
        return;
    }
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        if (i == 0) {
            self.upPoint = [AMapNaviPoint locationWithLatitude:[dic[ADDRESS_LAT] floatValue] longitude:[dic[ADDRESS_LON] floatValue]];

        }else if (i == array.count - 1){
            self.downPoint = [AMapNaviPoint locationWithLatitude:[dic[ADDRESS_LAT] floatValue] longitude:[dic[ADDRESS_LON] floatValue]];

        }else{
            [arr addObject:[AMapNaviPoint locationWithLatitude:[dic[ADDRESS_LAT] floatValue]  longitude:[dic[ADDRESS_LON] floatValue]]];
        }
    }
    [self.driverManager calculateDriveRouteWithStartPoints:@[self.upPoint] endPoints:@[self.downPoint] wayPoints:arr drivingStrategy:9];

}
- (void)calculateDistanceAndPriceWithStartLat:(double)lat StartLon:(double)lon EndLat:(double)endlat EndLon:(double)endlon{
    self.upPoint = [AMapNaviPoint locationWithLatitude:lat longitude:lon];
    self.downPoint = [AMapNaviPoint locationWithLatitude:endlat longitude:endlon];
    [self.driverManager calculateDriveRouteWithStartPoints:@[self.upPoint] endPoints:@[self.downPoint] wayPoints:nil drivingStrategy:9];

}

/** POI搜索回调 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0)
    {
        return;
    }
    
    if (self.searchPOISucess) {
        self.searchPOISucess(response.pois);
    }
}

/** 逆地理编码的回调 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil)
    {
        NSString *address;
        if (response.regeocode.pois.count > 0) {
            AMapAOI *poi = (AMapAOI *)response.regeocode.pois.firstObject;
            address = poi.name;
        }else{
            address = response.regeocode.formattedAddress;
        }
        self.cityName = response.regeocode.addressComponent.city;
        if (self.regeoSucess && !self.choseUpPlace) {
            self.regeoSucess(address, CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude));
        }
    }
}

/** 计算驾车路径成功的回调 */
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    if (self.calculateRouteSucess) {
        NSInteger time = driveManager.naviRoute.routeTime; self.calculateRouteSucess(driveManager.naviRoute.routeLength, [self changeTimeWithSeconds:time]);
    }
    
    //算路成功后显示路径
    [self showNaviRoutes];

}

// 把秒转换成小时或分钟
- (NSString *)changeTimeWithSeconds:(NSInteger)second{
    NSInteger minute = second / 60;
    if (minute < 60) {
        return [NSString stringWithFormat:@"%ld分钟", minute];
    }
    if (minute % 60 == 0) {
        return [NSString stringWithFormat:@"%ld小时", minute / 60];
    }
    
    return [NSString stringWithFormat:@"%ld小时%ld分钟", minute / 60 , minute % 60];
}

- (void)showNaviRoutes
{
    if ([self.driverManager.naviRoutes count] <= 0)
    {
        return;
    }
    
    
    for (NSNumber *aRouteID in [self.driverManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driverManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        YDPathOverLay *pathPolyline = [[YDPathOverLay alloc] initWithOverlay:polyline];
        
        [self.mapView addOverlay:pathPolyline];
        free(coords);
    
    }
    
//    [self addImageAnnotationWithLat:self.upPoint.latitude lon:self.upPoint.longitude type:YDImageAnnotationTypeUp];
//    [self addImageAnnotationWithLat:self.downPoint.latitude lon:self.downPoint.longitude type:YDImageAnnotationTypeDown];
    
    [self.mapView showOverlays:self.mapView.overlays edgePadding:UIEdgeInsetsMake(110, 50, 300, 50) animated:YES];


}

/** 计算失败的回调 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    DLog(@"==================%@", error);
    if (error.code == 13) {
        [self.driverManager calculateDriveRouteWithStartPoints:@[self.upPoint] endPoints:@[self.downPoint] wayPoints:nil drivingStrategy:9];
    }
}

/** 设置路线 */
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[YDPathOverLay class]])
    {
        YDPathOverLay * selectableOverlay = (YDPathOverLay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 4.f;
        circleRenderer.strokeColor = [UIColor blueColor];
        return circleRenderer;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    if ([view isKindOfClass:[YDPopAnnotationView class]]) {
        YDPopAnnotationView *cusView = (YDPopAnnotationView *)view;
//        [self.mapView setCenterCoordinate:cusView.location animated:YES];
        
        CLLocationCoordinate2D location = [self.mapView convertPoint:CGPointMake(cusView.center.x, cusView.center.y - 100) toCoordinateFromView:self.mapView];
        
        [self.mapView setCenterCoordinate:location animated:YES];
        
    }
}

/** 自定义大头针 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[YDImageAnnotation class]]) {
        YDImageAnnotation *ydAnnotation = (YDImageAnnotation *)annotation;
        
        static NSString *pointReuseIndentifier = @"YDImageAnnotation";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.layer.anchorPoint = CGPointMake(0.5, 1);
        annotationView.canShowCallout = YES;
        if (ydAnnotation.type == YDImageAnnotationTypeUp)
        {
            annotationView.image = [UIImage imageNamed:@"on"];
            return annotationView;
        }

        if (ydAnnotation.type == YDImageAnnotationTypeDown)
        {
            annotationView.image = [UIImage imageNamed:@"off"];
            return annotationView;
        }
        
        if (ydAnnotation.type == YDImageAnnotationWayPoint) {
            annotationView.image = [UIImage imageNamed:@"default_navi_route_waypoint"];
            
            return annotationView;
        }

    }else if([annotation isKindOfClass:[MAUserLocation class]]){
        return nil;
    }else if([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        YDPopAnnotationView*annotationView = (YDPopAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[YDPopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.location = annotation.coordinate;
        
        if (MACircleContainsCoordinate(annotation.coordinate, self.mapView.userLocation.coordinate, 500)) {
            annotationView.canShowCallout= NO;
            annotationView.pinColor = MAPinAnnotationColorGreen;
        }else{
            annotationView.enabled= NO;
            annotationView.pinColor = MAPinAnnotationColorPurple;

        }
            return annotationView;
    }
    return nil;
}

- (void)addAnnotionsWithArray:(NSArray *)array{
//    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *anns = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        if (i == 0) {
            YDImageAnnotation * ann = [self addImageAnnotationWithLat:[dic[ADDRESS_LAT] floatValue] lon:[dic[ADDRESS_LON] floatValue]  type:YDImageAnnotationTypeUp];
            ann.title = dic[ADDRESS_NAME];
            [anns addObject:ann];
        } else if (i == array.count - 1){
            YDImageAnnotation * ann = [self addImageAnnotationWithLat:[dic[ADDRESS_LAT] floatValue] lon:[dic[ADDRESS_LON] floatValue]  type:YDImageAnnotationTypeDown];
            ann.title = dic[ADDRESS_NAME];
            [anns addObject:ann];
        }else{
            YDImageAnnotation * ann = [self addImageAnnotationWithLat:[dic[ADDRESS_LAT] floatValue] lon:[dic[ADDRESS_LON] floatValue]  type:YDImageAnnotationWayPoint];
            ann.title = dic[ADDRESS_NAME];
            [anns addObject:ann];
        }
    }
    [self.mapView addAnnotations:anns];
}

///** 添加只有图片的大头针 */
- (YDImageAnnotation *)addImageAnnotationWithLat:(double)lat lon:(double)lon type:(YDImageAnnotationType)type{
    YDImageAnnotation *annotation = [[YDImageAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    annotation.type = type;
    [GLOABL.mapView addAnnotation:annotation];
    
    return annotation;

}

/** 清除所有的大头针 */
- (void)clearAnnotions{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
}
// 懒加载地图
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel = 16;
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.scrollEnabled = YES;
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
//        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = NO;
        r.image = [UIImage imageNamed:@"process_nowadr_icon"];
        [self.mapView updateUserLocationRepresentation:r];
    }
    return _mapView;
}

- (NSArray *)hotelPoints{
    if (!_hotelPoints) {
        NSArray *arr = @[@[@"31.232111", @"121.365569", @"金江家园"], @[@"31.23281", @"121.36168", @"建德花园牡丹苑"], @[@"31.227793", @"121.368648", @"上河湾"], @[@"31.228935", @"121.365991", @"馨越公寓"], @[@"31.235657", @"121.36486", @"金沙雅苑未来街区"]];
        _hotelPoints = [NSArray arrayWithArray:arr];

    }
    return _hotelPoints;
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.locatingWithReGeocode = YES;
    self.locationManager.distanceFilter = 50;
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        DLog(@"%@", reGeocode.city);

    if (self.regeoSucess && !self.choseUpPlace) {
        [GLOABL.mapView setCenterCoordinate:location.coordinate];
        self.cityName = reGeocode.city;

        self.regeoSucess(reGeocode.POIName, CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
    }
    
    // 添加围栏
//    if (self.circle) {
//        [self.mapView removeOverlays:self.mapView.overlays];
//    }
//    self.circle = [MACircle circleWithCenterCoordinate:location.coordinate radius:500];
//    [self.mapView addOverlays:@[self.circle]];
//
//    [self.mapView showOverlays:@[self.circle] edgePadding:UIEdgeInsetsMake(100, 20, 100, 20) animated:YES];
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
//    if (wasUserAction) {
//        if (self.allowChangeUp) {
//            CLLocationCoordinate2D location = [self.mapView convertPoint:self.geoPoint toCoordinateFromView:self.mapView.superview];
//            [self regeoWithLat:location.latitude lon:location.longitude];
//        }
//
//    }
}


- (AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (AMapNaviDriveManager *)driverManager{
    if (!_driverManager) {
        _driverManager = [[AMapNaviDriveManager alloc] init];
        [_driverManager setDelegate:self];
    }
    return _driverManager;
}

- (NSArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSArray alloc] init];
    }
    return _addressArray;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    DLog(@"==============%@", error);
    if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]]) {
        [self.search AMapReGoecodeSearch:request];
        return;
    }
    
}


@end
