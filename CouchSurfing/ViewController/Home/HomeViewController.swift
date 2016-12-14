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
        map.userTrackingMode = BMKUserTrackingModeHeading
        let param = BMKLocationViewDisplayParam()
        param.isAccuracyCircleShow = false
        param.isRotateAngleValid = false
        param.locationViewImgName = "userLocation_icon"
        map.updateLocationView(with: param)
        map.setCompassImage(UIImage(named: "userLocation_icon"))
        map.clearsContextBeforeDrawing = true
        map.isRotateEnabled = true
        return map
    }()
    
    let locSevice = BMKLocationService()
    
    fileprivate var shaFaKeList:[BMKPointAnnotation] = []
    fileprivate var userOverlay:BMKCircle = {
        var overlay = BMKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: ScreenUI.mapUserOverlayRadius)
        
        return overlay!
    }()
    
    fileprivate var lastLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    fileprivate let pakgBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "package"), for: .normal)
        return btn
    }()
    
    fileprivate let goOriginBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIimage(named: "origin_btn"), for: <#T##UIControlState#>)
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
        mapView.updateLocationData(userLocation)
        let location = userLocation.location.coordinate
        
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let rotation = userLocation.heading.magneticHeading - 90.0
        mapView.rotation = Int32(CGFloat(rotation))
    }
    
    @objc(didUpdateBMKUserLocation:) func didUpdate(_ userLocation: BMKUserLocation!){
        //大于5米更新
        let location = userLocation.location.coordinate
        let distance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(lastLocation), BMKMapPointForCoordinate(location))
        if distance > 5 {
            userOverlay.setCircleWithCenterCoordinate(location, radius: ScreenUI.mapUserOverlayRadius)
            mapView.removeAnnotations(shaFaKeList)
            shaFaKeList = []
            let region = BMKCoordinateRegion(center: location, span: BMKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
            for _ in 0...10 {
                let la:Double = Double(arc4random()%100 )/10000.0
                let lo:Double = Double(arc4random()%100)/10000.0
                addAnnotaionForSHAFA(CLLocationCoordinate2D(latitude: location.latitude - 0.005 + la , longitude: location.longitude - 0.005 + lo), title: "shafa")
            }
        }
    }
}

// MARK: - UI
extension HomeViewController{

    fileprivate func initUI(){
        view.backgroundColor = UIColor.purple
        titleStr = "沙发客"
        
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
        
        mapView.add(userOverlay)
        
        mapView.compassPosition = CGPoint(x: 10, y: 10)
        mapView.setCompassImage(UIImage(named: "userLocation_icon"))
        mapView.showMapScaleBar = true
        mapView.mapScaleBarPosition = CGPoint(x: ScreenUI.with - 100, y: ScreenUI.herght - 64 - 49 - 20)
    }
}
