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
    var viewWidth: CGFloat {
        return frame.size.width
    }
    
    /// 高度
    var viewHeight: CGFloat {
        return frame.size.height
    }
    
    /// Y
    var viewX: CGFloat {
        set(newValue){
            frame.origin.x = newValue
        }get{
            return frame.origin.x
        }
    }
    
    /// Y
    var viewY: CGFloat {
        set(newValue){
            frame.origin.y = newValue
        }get{
            return frame.origin.y
        }
    }
    
    /// centerX
    var viewCenterX: CGFloat {
        return center.x
    }
    
    /// centerY
    var viewCenterY: CGFloat {
        return center.y
    }
    
    /// size
    var viewSize: CGSize {
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
