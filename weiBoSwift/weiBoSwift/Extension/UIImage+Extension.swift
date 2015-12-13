//
//  UIImage+Extension.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

import Foundation

extension UIImage {
    
    // 讲图片缩小成指定大小
    // 参数：最小宽度跟高度
    // 返回值：缩小后的图片
    func image(maxWith: CGFloat, maxHeight: CGFloat) -> UIImage {
        // 判断以那个方向缩小
        var imageWith: CGFloat = 0
        var imageHeight: CGFloat = 0
        if size.width / size.height > maxWith / maxHeight { // 以宽度作为缩放
            imageWith = maxWith
            imageHeight = size.height * (imageWith / size.width)
        }else{ // 以高度作为缩放
            imageHeight = maxHeight
            imageWith = size.width * (imageHeight / size.height)
        }
        // 获取上下文
        UIGraphicsBeginImageContext(CGSize(width: imageWith, height: imageHeight))
        // 画图
        drawInRect(CGRect(x: 0, y: 0, width: imageWith, height: imageHeight))
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
}