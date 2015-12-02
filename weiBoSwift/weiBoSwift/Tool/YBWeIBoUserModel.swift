//
//  YBWeIBoUserModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBWeIBoUserModel: NSObject {
    
    /// 友好显示名称
    var name: String?
    /// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
    @objc private var verified_type: Int = -1 {
        didSet {
            switch verified_type {
            case 0 : verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5 : verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220 : verifiedImage = UIImage(named: "avatar_grassroot")
            default : verifiedImage = nil
            }
        }
    }
    /// 会员等级 1-6
    var mbrank: Int = 0 {
        didSet {
            if mbrank == 0 {
                vipImage = UIImage(named: "common_icon_membership_expired")
            }else{
                vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    // profile_image_url string 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    // -----------转换-------------
    /// 认证图片
    var verifiedImage: UIImage?
    /// VIP
    var vipImage: UIImage?
    
    // MARK: - 构造方法
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
}
