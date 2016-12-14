//
//  HomeViewController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class HomeViewController: NavigationViewController ,BMKMapViewDelegate, BMKLocationServiceDelegate{
    
//MARK: - data
    //定位服务
    let locSevice = BMKLocationService()
    //沙发坐标
    fileprivate var shaFaKeList:[BMKPointAnnotation] = []
    //最后坐标
    fileprivate var lastLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //上次旋转角度
    fileprivate var lastRotaion:Double = 0.0
    
//MARK: - view
    var mapView: BMKMapView = {
        let map = BMKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = BMKUserTrackingModeNone
        map.setCompassImage(UIImage(named: "userLocation_icon"))
        map.clearsContextBeforeDrawing = true
        map.isRotateEnabled = true
        
        let param = BMKLocationViewDisplayParam()
        param.isAccuracyCircleShow = false
        param.isRotateAngleValid = false
        //需要放到百度bundle中因为git忽略了pods文件无法显示
//        param.locationViewImgName = "origin_btn"
        map.updateLocationView(with: param)
        return map
    }()
    fileprivate var userOverlay:BMKCircle = {
        var overlay = BMKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: ScreenUI.mapUserOverlayRadius)
        
        return overlay!
    }()
    
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
    
    fileprivate let reserveBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: ""), for: .normal)
        btn.backgroundColor = ScreenUI.mapCircelColor
        return btn
    }()
//MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        mapView.delegate = self
        locSevice.delegate = self
        locSevice.startUserLocationService()
        
        
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
        
        view.addSubview(reserveBtn)
        reserveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-27)
            make.width.equalTo(250)
            make.height.equalTo(44)
            make.centerX.equalTo(view).offset(18)
        }
        reserveBtn.addTarget(self, action: #selector(HomeViewController.reserveBtnDidClicked), for: .touchUpInside)
        
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
    
    func reserveBtnDidClicked() {
        HomeProgressHUD.show(HUDConfig())
        UIView.animate(withDuration: 0.25, animations:{
            self.reserveBtn.alpha = 0.0
        })
    }
}
