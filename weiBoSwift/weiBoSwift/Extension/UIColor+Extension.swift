//
//  UIColor+Extension.swift
//  weiBoSwift
//
//  Created by MAC on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 返回一个随机颜色
    class func randomColor() -> UIColor {
        return UIColor(colorLiteralRed: randomNum(), green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    
    private class func randomNum() -> Float {
        return Float(arc4random_uniform(256)) / 255
    }
    
}