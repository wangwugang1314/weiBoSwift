//
//  UIView+Extension.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/1.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 宽度
    var width: CGFloat {
        return frame.size.width
    }
    
    /// 高度
    var height: CGFloat {
        return frame.size.height
    }
    
    /// Y
    var X: CGFloat {
        set(newValue){
            frame.origin.x = newValue
        }get{
            return frame.origin.x
        }
    }
    
    /// Y
    var Y: CGFloat {
        set(newValue){
            frame.origin.y = newValue
        }get{
            return frame.origin.y
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        return center.x
    }
    
    /// centerY
    var centerY: CGFloat {
        return center.y
    }
    
    /// size
    var size: CGSize {
        return bounds.size
    }
    
    /// 圆角半径
    var cornerRadius: CGFloat {
        get{
            return 0.0
        }set(newValue){
            layer.masksToBounds = true;
            layer.cornerRadius = newValue;
        }
    }
}
