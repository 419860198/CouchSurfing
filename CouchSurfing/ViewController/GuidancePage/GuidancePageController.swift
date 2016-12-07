//
//  GuidancePageController.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/6.
//  Copyright © 2016年 monstar. All rights reserved.
//

import UIKit
class GuidancePageController: UIViewController {
    
    fileprivate let guidanceImages = ["guidancePage_1","guidancePage_2","guidancePage_3","guidancePage_4","guidancePage_5"]
    fileprivate let guidancePageView:UIScrollView = {
        let view = UIScrollView()
        view.bouncesZoom = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.isPagingEnabled = true
        
        return view
    }()
    var toucheBlock:(()->())?

    
// MARK: -  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initGuidancePageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - private function
extension GuidancePageController{
    fileprivate func initGuidancePageView(){
        guidancePageView.frame = view.bounds
        guidancePageView.contentSize = CGSize(width: ScreenUI.with * CGFloat(integerLiteral: guidanceImages.count), height: ScreenUI.herght)
        view.addSubview(guidancePageView)
        
        for (i,imageName) in guidanceImages.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            let frame:CGRect = CGRect(x: CGFloat(i) * ScreenUI.with, y:0.0 , width: ScreenUI.with, height: ScreenUI.herght)
            imageView.frame = frame
            guidancePageView.addSubview(imageView)
            if i == guidanceImages.count-1 {
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GuidancePageController.guidancePageDidTouche(_:))))
            }
        }
    }
    
    @objc fileprivate func guidancePageDidTouche(_ sender: AnyObject){
        
        if toucheBlock != nil{
            UserDataManager.manager().guidancePageShow = true
            toucheBlock!()
        }
    }
}
