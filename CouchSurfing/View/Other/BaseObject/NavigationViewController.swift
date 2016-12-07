//
//  NavigationViewController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {
    
    public let navigationView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    public var navigationColor:UIColor {
        get{ return navigationView.backgroundColor! }
        set{ navigationView.backgroundColor = newValue }
    }
    
    public let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        return label
    }()
    
    public var titleStr:String? {
        get{return titleLabel.text}
        set{titleLabel.text = newValue}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        
        navigationView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 64)
        view.addSubview(navigationView)
        navigationView.backgroundColor = UINavigationBar.appearance().backgroundColor
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(navigationView)
            make.centerY.equalTo(navigationView).offset(10)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
