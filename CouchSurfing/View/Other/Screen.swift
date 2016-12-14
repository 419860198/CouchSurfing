//
//  Screen.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/6.
//  Copyright © 2016年 monstar. All rights reserved.
//

import Foundation
import UIKit

struct ScreenUI {
    static let with:CGFloat = UIScreen.main.bounds.width
    static let herght:CGFloat = UIScreen.main.bounds.height
    static let mainColor:UIColor = UIColor(convertHex: 0x008de7)
    static let tinBlackColor:UIColor = UIColor(convertHex:0x666666)
    
    static let mapCircelColor:UIColor = UIColor(convertHex:0x000000, alpha:0.1)
    static let mapUserOverlayRadius:Double = 700
    static let naviLeft_Margin:CGFloat = 14
}
