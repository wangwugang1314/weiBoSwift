//
//  UIButton+Extension.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 创建并设置图片
    convenience init(titleText: String?, imageName: String?){
        self.init()
        // 设置文字
        setTitle(titleText, forState: UIControlState.Normal)
//        // 设置图片
//        setImage(UIImage(named: imageName ?? ""), forState: UIControlState.Normal)
//        // 设置高亮图片
//        setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Selected)
        setImage(UIImage(named: "tabbar_profile_highlighted"), forState: UIControlState.Normal)
    }
}
