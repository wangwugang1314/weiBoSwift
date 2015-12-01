//
//  YBWeiBoModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBWeiBoModel: NSObject {
    
    // MARK: - 属性
    // 微薄id
    var id = 0
    /// MARK: 微博创建时间
    var created_at: String?
    /// MARK: 微博信息内容
    var text: String?
    /// MARK: 微博来源
    var source: String?
    /// MARK: 微博作者的用户信息字段 详细
    var user: AnyObject? {
        didSet{
            user = YBWeiBoModel(dic: user as! [String: AnyObject])
        }
    }
    /// MARK: 转发微博
    var retweeted_status: AnyObject?
    /// MARK: 图片
    var pic_urls: [[String: String]]?
    /// 当为一张图片的时候图片的大小
    var imageSize: CGSize = CGSizeMake(0, 0)
    /// MARK: 图片数组的Url
    var pictureURLs = [NSURL]()
    /// 大图的url
    var bigPictureUrls = [NSURL]()
    /// MARK: 行高
    var rowHeight: CGFloat?
    
    // MARK: - 构造方法
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK: - 微薄数据加载
    class func loadWeiBoData(finish: (dataArr: [YBWeiBoModel]?, isError: Bool) -> ()){
        // 加载数据
        YBNetworking.sharedInstance.loadWeiBoData { (result, error) -> () in
            // 判断是否有错误
            if error == nil {   // 加载成功
                if let yResult = result{ // 加载到数据
                    var weiBoArr = [YBWeiBoModel]()
                    // 遍历数组
                    for data in yResult{
                        weiBoArr.append(YBWeiBoModel(dic: data))
                    }
                    finish(dataArr: weiBoArr, isError: false)
                }else{  // 没有新数据
                    finish(dataArr: nil, isError: false)
                }
            }else{  // 数据加载出错
                finish(dataArr: nil, isError: true)
            }
        }
    }
}













