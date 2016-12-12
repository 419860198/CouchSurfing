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
        return map
    }()
    
    let locSevice = BMKLocationService()
    fileprivate let pakgBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "package"), for: .normal)
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
    }
    
    func drawUserRound(_ center:CGPoint) {
        
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
        }
        return nil
    }
    
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        let location = userLocation.location.coordinate
        
        for _ in 0...10 {
            let la:Double = Double(arc4random()%100 )/10000.0
            let lo:Double = Double(arc4random()%100)/10000.0
            addAnnotaionForSHAFA(CLLocationCoordinate2D(latitude: location.latitude - 0.005 + la , longitude: location.longitude - 0.005 + lo), title: "shafa")
        }
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = BMKCoordinateRegion(center: location, span: BMKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
        locSevice.stopUserLocationService()
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
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
        mapView.compassPosition = CGPoint(x: 10, y: 10)
        mapView.showMapScaleBar = true
        mapView.mapScaleBarPosition = CGPoint(x: ScreenUI.with - 100, y: ScreenUI.herght - 64 - 49 - 20)
    }
}
