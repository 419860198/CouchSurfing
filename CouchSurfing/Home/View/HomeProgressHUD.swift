//
//  HomeHUD.swift
//  CouchSurfing
//
//  Created by BG on 12/14/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

struct HUDConfig {
    var backGroundColor:UIColor = UIColor.clear
    var contentViewColor:UIColor = UIColor.white
    var tintColor:UIColor = UIColor.blue
    var title:String = "正在寻找沙发主"
    var message:String = "请耐心等待"
    
}

class HomeProgressHUD: UIView {
    static let shareView:HomeProgressHUD = HomeProgressHUD(frame: (UIApplication.shared.keyWindow?.bounds)!)
    
    var config:HUDConfig = HUDConfig()
    
    let hudView:UIVisualEffectView = {
        let visual = UIVisualEffectView()
        visual.layer.masksToBounds = true
        var arm1 = UIViewAutoresizing()
        arm1.formUnion(UIViewAutoresizing.flexibleBottomMargin)
        arm1.formUnion(UIViewAutoresizing.flexibleTopMargin)
        arm1.formUnion(UIViewAutoresizing.flexibleRightMargin)
        arm1.formUnion(UIViewAutoresizing.flexibleLeftMargin)
        visual.autoresizingMask = arm1
        
        return visual
    }()
    
    let titleLable:UILabel = {
        let lable = UILabel()
        
        return lable
    }()
    
    let messageLable:UILabel = {
        let lable = UILabel()
        
        return  lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        addSubview(hudView)
        hudView.layer.cornerRadius = 5;
        hudView.layer.backgroundColor = config.backGroundColor.cgColor
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeProgressHUD{
    
    static func show(_ config:HUDConfig){
        
        shareView.updateHUDFrame()
        
    }
    
    private func updateHUDFrame() {
        
    }
}
