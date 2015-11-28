//
//  YBDefaultData.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/27.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBDefaultData: NSObject {
    
    // 获取偏好设置
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    class func setObject(value: String, key: String) {
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setInt(value: Int, key: String) {
        defaults.setInteger(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setFloat(value: Float, key: String) {
        defaults.setFloat(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setDouble(value: Double, key: String) {
        defaults.setDouble(value, forKey: key)
        defaults.synchronize()
    }

    class func setBool(value: Bool, key: String) {
        defaults.setBool(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setURL(value: NSURL, key: String) {
        defaults.setURL(value, forKey: key)
        defaults.synchronize()
    }

    class func objectForKey(key: String) -> String {
        return defaults.objectForKey(key) as! String
    }
    
    class func intForKey(key: String) -> Int {
        return defaults.integerForKey(key)
    }

    class func floatForKey(key: String) -> Float {
        return defaults.floatForKey(key)
    }
    
//    + (double)doubleForKey:(NSString *)defaultName{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults doubleForKey:defaultName];
//    }
    
    class func boolForKey(key: String) -> Bool {
        return defaults.boolForKey(key)
    }

//    + (NSURL *)URLForKey:(NSString *)defaultName{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults URLForKey:defaultName];
//    }

//    + (NSArray *)arrayForKey:(NSString *)defaultName{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults arrayForKey:defaultName];
//    }
//    + (NSDictionary *)dictionaryForKey:(NSString *)defaultName{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults dictionaryForKey:defaultName];
//    }
//    + (NSData *)dataForKey:(NSString *)defaultName{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults dataForKey:defaultName];
//    }
}
