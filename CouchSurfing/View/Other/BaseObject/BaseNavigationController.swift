//
//  BaseNavigationController.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/7.
//  Copyright © 2016年 monstar. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    fileprivate let naviBar:UINavigationBar = {
        let navibar = UINavigationBar()
        
        return navibar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.isHidden = true
        
        naviBar.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 64.0)
        view.addSubview(naviBar)
        
    }

}
