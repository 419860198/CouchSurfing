//
//  HomeViewController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class HomeViewController: NavigationViewController ,BMKMapViewDelegate{

    var mapView: BMKMapView = {
        let map = BMKMapView()
        
        return map
    }()
    fileprivate let pakgBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "package"), for: .normal)
        return btn
    }()

//MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        let annotaion = BMKPointAnnotation()
        var coor = CLLocationCoordinate2D()
        coor.latitude = 39.915
        coor.longitude = 116.404
        annotaion.coordinate = coor
        annotaion.title = "这里是北京"
        mapView.addAnnotation(annotaion)
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

}

// MARK: - BMKmapView delegate
extension HomeViewController{
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKAnnotation.self) {
            let newAnnotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "newAnnotaion")
        //    newAnnotationView.animatesDrop = YES
            
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
    }
}
