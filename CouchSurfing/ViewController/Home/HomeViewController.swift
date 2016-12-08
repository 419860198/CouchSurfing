//
//  HomeViewController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class HomeViewController: NavigationViewController ,BMKMapViewDelegate{

    var mapView: BMKMapView = BMKMapView()

//MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        titleStr = "HOME"
        view.addSubview(mapView)
        mapView.snp.makeConstraints({ (make) in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        })
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let log = LoginViewController()
        log.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(log, animated: true)
    }

}
