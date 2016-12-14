//
//  HomeViewController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class HomeViewController: NavigationViewController ,BMKMapViewDelegate, BMKLocationServiceDelegate{
    
    
    var mapView: BMKMapView = {
        let map = BMKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = BMKUserTrackingModeFollow
        map.setCompassImage(UIImage(named: "userLocation_icon"))
        map.clearsContextBeforeDrawing = true
        map.isRotateEnabled = true
        
        let param = BMKLocationViewDisplayParam()
        param.isAccuracyCircleShow = false
        param.isRotateAngleValid = false
        param.locationViewImgName = "userLocation_icon"
        map.updateLocationView(with: param)
        return map
    }()
    
    let locSevice = BMKLocationService()
    
    fileprivate var shaFaKeList:[BMKPointAnnotation] = []
    fileprivate var userOverlay:BMKCircle = {
        var overlay = BMKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: ScreenUI.mapUserOverlayRadius)
        
        return overlay!
    }()
    
    fileprivate var lastLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    fileprivate var lastRotaion:Double = 0.0
    
    fileprivate let pakgBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "package"), for: .normal)
        return btn
    }()
    
    fileprivate let goOriginBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "origin_btn"), for: .normal)
        
        return btn
    }()
    
//MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locSevice.delegate = self
        locSevice.startUserLocationService()
        
        initUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil // 不用时，置nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - private func
    func addGroundOverlay(_ position:CLLocationCoordinate2D) {
        let ground = BMKGroundOverlay(position: position, zoomLevel: 11, anchor: CGPoint.zero, icon: UIImage(named: "appIcon"))
        mapView.add(ground)
        
    }
    
    func addAnnotaion() {
        let annotaion = BMKPointAnnotation()
        var coor = CLLocationCoordinate2D()
        coor.latitude = 39.915
        coor.longitude = 116.404
        annotaion.coordinate = coor
        annotaion.title = "这里是北京"
        mapView.addAnnotation(annotaion)
    }
    
    func addAnnotaionForSHAFA(_ location:CLLocationCoordinate2D, title:String) {
        let shafaAnnotation = BMKPointAnnotation()
        shafaAnnotation.coordinate = location
        shafaAnnotation.title = title
        mapView.addAnnotation(shafaAnnotation)
        shaFaKeList.append(shafaAnnotation)
    }


}

// MARK: - BMKmapView delegate
extension HomeViewController{
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self) {
            let newAnnotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "newAnnotaion")
        //    newAnnotationView.animatesDrop = YES
            newAnnotationView?.image = UIImage(named: "location_icon")
            
            return newAnnotationView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay.isKind(of: BMKGroundOverlay.self) {
            let groundView = BMKGroundOverlayView(groundOverlay: overlay as! BMKGroundOverlay!)
            return groundView
        }else if overlay.isKind(of: BMKCircle.self){
            let circelView = BMKCircleView(overlay: overlay)
            circelView?.fillColor = ScreenUI.mapCircelColor
            circelView?.strokeColor = ScreenUI.mapCircelColor
            circelView?.lineWidth = 0.0
            return circelView
            
        }
        return nil
    }
    
    @objc(didUpdateUserHeading:) func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        //大于5才旋转
        let rotation = userLocation.heading.magneticHeading - 90.0
        if abs(lastRotaion - rotation) < 5{ return  }
        lastRotaion = rotation
        mapView.rotation = Int32(CGFloat(rotation))
    }
    
    @objc(didUpdateBMKUserLocation:) func didUpdate(_ userLocation: BMKUserLocation!){
        //大于5米更新
        let location = userLocation.location.coordinate
        let distance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(lastLocation), BMKMapPointForCoordinate(location))
        mapView.updateLocationData(userLocation)
        if distance > 5 {
            if lastLocation.latitude == 0 && lastLocation.longitude == 0 {
                lastLocation = location
                self.originBtnDidClicked()
            }
            //移除大头针和添加大头针
            mapView.removeAnnotations(shaFaKeList)
            shaFaKeList = []
            for _ in 0...10 {
                let la:Double = Double(arc4random()%100 )/10000.0
                let lo:Double = Double(arc4random()%100)/10000.0
                addAnnotaionForSHAFA(CLLocationCoordinate2D(latitude: location.latitude - 0.005 + la , longitude: location.longitude - 0.005 + lo), title: "shafa")
            }
            lastLocation = location
        }
    }
}

// MARK: - UI
extension HomeViewController{

    fileprivate func initUI(){
        view.backgroundColor = UIColor.purple
        titleStr = "沙发客"
        //
        navigationView.addSubview(pakgBtn)
        
        pakgBtn.snp.makeConstraints { (make) in
            make.left.equalTo(navigationView).offset(ScreenUI.naviLeft_Margin)
            make.width.equalTo(22)
            make.height.equalTo(17)
            make.centerY.equalTo(navigationView).offset(10)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints({ (make) in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        })
        
        view.addSubview(goOriginBtn)
        goOriginBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.left.equalTo(view).offset(16)
            make.bottom.equalTo(view.snp.bottom).offset(-27)
        }
        goOriginBtn.addTarget(self, action: #selector(HomeViewController.originBtnDidClicked), for: .touchUpInside)
        
        mapView.add(userOverlay)
        
        mapView.compassPosition = CGPoint(x: 10, y: 10)
        mapView.setCompassImage(UIImage(named: "userLocation_icon"))
        mapView.showMapScaleBar = true
        mapView.mapScaleBarPosition = CGPoint(x: ScreenUI.with - 100, y: ScreenUI.herght - 64 - 49 - 20)
    }
}

extension HomeViewController{
    func originBtnDidClicked() {
        //设置中心
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
        //设置显示区域
        let region = BMKCoordinateRegion(center: lastLocation, span: BMKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
        //画圆
        userOverlay.setCircleWithCenterCoordinate(lastLocation, radius: ScreenUI.mapUserOverlayRadius)
    }
}
