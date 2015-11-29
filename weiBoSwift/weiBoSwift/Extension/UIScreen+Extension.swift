//
//  UIScreen+Extension.swift
//  weiBoSwift
//
//  Created by apple on 15/11/1.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

extension UIScreen {
    
    // 屏幕宽度
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    // 屏幕高度
    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    // 屏幕bounda
    class func bounds() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    // 屏幕大小
    class func size() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
}
