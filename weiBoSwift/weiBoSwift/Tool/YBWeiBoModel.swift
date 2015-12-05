//
//  YBWeiBoModel.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SDWebImage

class YBWeiBoModel: NSObject {
    
    // MARK: - 属性
    // 微薄id
    var id = 0
    /// MARK: 微博创建时间
    var created_at: String? {
        didSet{
            created_at = weiBoDataSwitch(created_at ?? "")
        }
    }
    /// MARK: 微博信息内容
    var text: String?
    /// MARK: 微博来源
    var source: String? {
        didSet {
            source = weiBoSourceSwitch(source ?? "")
        }
    }
    /// MARK: 微博作者的用户信息字段 详细
    var user: AnyObject? {
        didSet{
            user = YBWeIBoUserModel(dic: user as! [String: AnyObject])
        }
    }
    /// MARK: 转发微博
    var retweeted_status: AnyObject? {
        didSet {
            let weiBoModel = YBWeiBoModel(dic: retweeted_status as! [String: AnyObject])
            retweeted_status = weiBoModel
            pic_urls = weiBoModel.pic_urls
        }
    }
    /// MARK: 图片
    @objc private var pic_urls: [[String: String]]? {
        didSet {
            for picDic in pic_urls! {
                imageURLs.append(NSURL(string: picDic["thumbnail_pic"]!)!)
                // 设置大图的url
                // 获取图片地址
                bigPictureUrls.append(NSURL(string: picDic["thumbnail_pic"]!.stringByReplacingOccurrencesOfString("thumbnail", withString: "large"))!)
            }
        }
    }
    // -----------------------------------------
    /// 当为一张图片的时候图片的大小
    var imageSize: CGSize = CGSizeMake(0, 0)
    /// MARK: 图片数组的Url
    var imageURLs = [NSURL]()
    /// 大图的url
    var bigPictureUrls = [NSURL]()
    /// MARK: 行高
    var rowHeight: CGFloat?
    /// 当前点击的图片索引
    var index: Int = 0;
    /// 当前点击所有的位置
    var imageViewFrames: [CGRect]?
    
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
                var weiBoArr = [YBWeiBoModel]()
                // 遍历数组
                for data in result! {
                    weiBoArr.append(YBWeiBoModel(dic: data))
                }
                loadImages(weiBoArr, finish: finish)
            }else{  // 数据加载出错
                finish(dataArr: nil, isError: true)
            }
        }
    }
    
    /// 加载所有单张图片
    private class func loadImages(dataArr: [YBWeiBoModel], finish: (dataArr: [YBWeiBoModel]?, isError: Bool) -> ()){
        // 设置GCD group
        let group = dispatch_group_create()
        // 遍历数组
        for data in dataArr {
            if data.imageURLs.count == 1 {
                // 队列进组
                dispatch_group_enter(group)
                // 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(data.imageURLs[0], options: SDWebImageOptions(rawValue: 0), progress: { (_, _) -> Void in
                    }, completed: {[unowned data] (image, error, _, _, _) -> Void in
                        // 队列出租
                        dispatch_group_leave(group)
                        // 判断图片是否加载成功
                        if error == nil && image != nil { // 加载到图片
                            // 如果图片太窄就设置默认大小
                            if image.size.width < 40 {
                                data.imageSize = CGSizeMake(80, 90)
                            }else if image.size.width > UIScreen.width() - 20 {
                                data.imageSize = CGSizeMake(UIScreen.width() - 20, image.size.height * (UIScreen.width() / image.size.height))
                            } else {
                                data.imageSize = CGSizeMake(image.size.width, image.size.height)
                            }
                        }else{ // 加载错误
                            data.imageSize = CGSizeMake(80, 90)
                        }
                })
            }
        }
        // 组全部执行完执行
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            finish(dataArr: dataArr, isError: false)
        }
    }
    
    //    刚刚(一分钟内)
    //    X分钟前(一小时内)
    //    X小时前(当天)
    //    昨天 HH:mm(昨天)
    //    MM-dd HH:mm(一年内)
    //    yyyy-MM-dd HH:mm(更早期)
    /// 时间转换
    private func weiBoDataSwitch(str: String) -> String {
        let dateF = NSDateFormatter()
        dateF.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        let date = dateF.dateFromString(str) ?? NSDate()
        let calendar = NSCalendar.currentCalendar()
        // 判断时间
        if calendar.compareDate(date, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.Year) == NSComparisonResult.OrderedSame { // 今年
            if calendar.isDateInToday(date) {// 今天
                let timeInterval = date.timeIntervalSinceDate(NSDate())
                if timeInterval < 60 { // 一分钟内
                    return "刚刚"
                } else if timeInterval < 3600 { // 一小时内
                    return "\(Int(timeInterval / 60))分钟前"
                } else { // 当天
                    return "\(Int(timeInterval / 3600))小时前"
                }
            }else if calendar.isDateInYesterday(date) { // 昨天
                dateF.dateFormat = "HH:mm"
                return "昨天\(dateF.stringFromDate(date))"
            }else{ // 一年内
                dateF.dateFormat = "MM-dd HH:mm"
            }
        }else{ // 更早期
            dateF.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return dateF.stringFromDate(date)
    }
    
    /// 微薄来源
    private func weiBoSourceSwitch(str: String) -> String {
        if str == "" {return ""}
        let regularExpression = try? NSRegularExpression(pattern: ">(.*?)</a>", options: NSRegularExpressionOptions(rawValue: 0))
        if regularExpression == nil {return ""}
        
        let result = regularExpression?.firstMatchInString(str, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: str.characters.count))
        
        if result == nil {return ""}
        
        if result!.numberOfRanges > 0 {
            return (str as NSString).substringWithRange(result!.rangeAtIndex(1))
        }
        return ""
    }
}













