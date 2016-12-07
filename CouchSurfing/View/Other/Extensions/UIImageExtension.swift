//
//  UIImageExtension.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/7.
//  Copyright © 2016年 monstar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    static func tint(color: UIColor, blendMode: CGBlendMode, size:CGSize) -> UIImage {
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.setFill()
        UIRectFill(drawRect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
