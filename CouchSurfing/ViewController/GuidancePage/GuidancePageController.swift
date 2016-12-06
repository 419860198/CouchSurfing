//
//  GuidancePageController.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/6.
//  Copyright © 2016年 monstar. All rights reserved.
//

import UIKit
class GuidancePageController: UIViewController {
    
    private let guidanceImages = ["guidancePage_1","guidancePage_2","guidancePage_3","guidancePage_4","guidancePage_5"]
    private let guidancePageView:UIScrollView = UIScrollView.init()
    var toucheBlock:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGuidancePageView()
    }
    
// MARK: - private function
    func initGuidancePageView(){
        guidancePageView.frame = view.bounds
        guidancePageView.contentSize = CGSize(width: ScreenUI.with * CGFloat(integerLiteral: guidanceImages.count), height: ScreenUI.herght)
        guidancePageView.bouncesZoom = true
        guidancePageView.showsVerticalScrollIndicator = false
        guidancePageView.showsHorizontalScrollIndicator = false
        guidancePageView.bounces = false
        guidancePageView.isPagingEnabled = true
        view.addSubview(guidancePageView)
        
        for i in 0 ..< guidanceImages.count {
            let imageView = UIImageView(image: UIImage(named: guidanceImages[i]))
            let frame:CGRect = CGRect(x: CGFloat(i) * ScreenUI.with, y:0.0 , width: ScreenUI.with, height: ScreenUI.herght)
            imageView.frame = frame
            guidancePageView.addSubview(imageView)
            if i == guidanceImages.count-1 {
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GuidancePageController.guidancePageDidTouche(_:))))
            }
        }
    }
    
    func guidancePageDidTouche(_ sender: AnyObject){
        
        if toucheBlock != nil{
            toucheBlock!()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
