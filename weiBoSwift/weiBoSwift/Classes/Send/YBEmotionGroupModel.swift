//
//  YBEmotionGroupModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBEmotionGroupModel: NSObject {

    // MARK: - 属性
    /// id (文件夹名称)
    @objc private var id: String? {
        didSet {
            let path = NSBundle.mainBundle().pathForResource("Emoticons.bundle/\(id!)/info.plist", ofType: nil)
            // 获取字典
            let dic = NSDictionary(contentsOfFile: path!)
            // 设置组名
            groupName = dic!["group_name_cn"] as? String
            // 获取表情数组
            let arr = dic!["emoticons"] as? [[String: AnyObject]]
            // 获取数组
            emotions = YBEmotionModel.emotionModels(arr, id: id)
        }
    }
    /// 组名
    var groupName: String?
    /// 表情数组
    var emotions: [YBEmotionModel]? {
        didSet {
            pageNum = emotions!.count / 21
        }
    }
    /// 页数
    var pageNum = 1
    
    // MARK: - 构造方法
    convenience init(dic: [String: AnyObject]) {
        self.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK: - 表情组模型
    class func emotionGroupModels() -> [YBEmotionGroupModel]? {
        // 路径
        let path = NSBundle.mainBundle().pathForResource("Emoticons.bundle/emoticons.plist", ofType: nil)
        // 获取数组
        let arr = NSDictionary(contentsOfFile: path!)!["packages"] as! [[String: AnyObject]]
        // 创建可变数组
        var groupModels = [YBEmotionGroupModel]()
        
        // 添加最近组
        let latelyGroup = YBEmotionGroupModel()
        latelyGroup.groupName = "最近"
        // 添加空数据跟删除按钮
        var emtions = [YBEmotionModel]()
        for index in 0..<21 {
            let del = YBEmotionModel()
            if index == 20 {
                del.deleteStr = "compose_emotion_delete_highlighted"
            }
            emtions.append(del)
        }
        latelyGroup.emotions = emtions
        groupModels.append(latelyGroup)
        
        // 遍历数组
        for data in arr {
            groupModels.append(YBEmotionGroupModel(dic: data))
        }
        return groupModels
    }
}
