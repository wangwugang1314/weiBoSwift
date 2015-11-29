//
//  YBIsNewVersion.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBIsNewVersion: NSObject {
    // 判断新版本
    class func isNewVersion() -> Bool {
        
        let versionKey = "CFBundleVersion"
        // 获取偏好设置
        let userDef = NSUserDefaults.standardUserDefaults()
        // 获取当前版本
        let currentVersion = (NSBundle.mainBundle().infoDictionary![versionKey])! as! String
        // 获取沙河版本
        let defaultVersion = (userDef.objectForKey(versionKey)) as? String
        // 保存数据
        userDef.setObject(currentVersion, forKey: versionKey)
        
        // 判断两个版本是否相同
        if let defaultV = defaultVersion{
            
            if defaultV == currentVersion {
                // 版本相同
                return false
            }
        }
        // 版本不同
        return true
    }
}
