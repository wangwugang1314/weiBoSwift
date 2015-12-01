//
//  YBWeIBoUserModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBWeIBoUserModel: NSObject {
    
    /// 用户UID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    /// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
    var verified_type: Int = -1
    /// 会员等级 1-6
    var mbrank: Int = 0
    // profile_image_url string 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    // MARK: - 构造方法
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {}
    
    
}
