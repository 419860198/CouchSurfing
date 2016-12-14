//
//  UIColorExtension.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/6.
//  Copyright © 2016年 monstar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    
    convenience init(convertHex:UInt32 ) {
        self.init(red: CGFloat((convertHex & 0xFF0000) >> 16)/255.0,
                   green:  CGFloat((convertHex & 0xFF00) >> 8)/255.0,
                   blue: CGFloat((convertHex & 0xFF))/255.0,
                   alpha: 1.0)
    }
    convenience init(convertHex:UInt32, alpha:CGFloat ) {
        self.init(red: CGFloat((convertHex & 0xFF0000) >> 16)/255.0,
                  green:  CGFloat((convertHex & 0xFF00) >> 8)/255.0,
                  blue: CGFloat((convertHex & 0xFF))/255.0,
                  alpha: alpha)
    }
}
