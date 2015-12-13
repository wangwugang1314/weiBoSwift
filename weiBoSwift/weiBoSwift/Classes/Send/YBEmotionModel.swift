//
//  YBEmotionModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBEmotionModel: NSObject {

    // MARK: - 属性
    /// emoji表情
    var code: String? {
        didSet {
            code = YBEmoji.emoji(code)
        }
    }
    /// 名称 
    var chs: String?
    /// 图片名称
    var png: String?
    /// 删除按钮
    var deleteStr: String?
    /// 点击次数
    var selNum = 0
    
    // MARK: - 构造方法
    convenience init(dic: [String: AnyObject]) {
        self.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 获取表情
    class func emotionModels(arr:[[String: AnyObject]]?, id: String?) -> [YBEmotionModel]? {
        // 创建可变数组
        var mArr = [YBEmotionModel]()
        // 遍历数组
        for index in 0..<arr!.count {
            // 如果是二十的倍数添加删除按钮
            if index != 0 && index % 20 == 0 {
                mArr.append(YBEmotionModel.delEmotion())
            }
            let emotionModel = YBEmotionModel(dic: arr![index])
            // 设置地址
            if emotionModel.png != nil {
                var imageStr = "Emoticons.bundle/\(id!)/\(emotionModel.png!)"
                if id == "com.sina.default" {
                    imageStr = imageStr.stringByReplacingOccurrencesOfString(".png", withString: "@3x.png")
                }
                let path = NSBundle.mainBundle().pathForResource(imageStr, ofType: nil)
                emotionModel.png = path
            }
            mArr.append(emotionModel)
            if index == arr!.count - 1 {
                mArr.append(YBEmotionModel.delEmotion())
            }
        }
        
        return mArr
    }
    
    // 删除按钮
    class func delEmotion() -> YBEmotionModel {
        let del = YBEmotionModel()
        del.deleteStr = "compose_emotion_delete_highlighted"
        return del
    }
}
