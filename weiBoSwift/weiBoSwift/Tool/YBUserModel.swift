//App Key：2811696621
//App Secret：283af988db3ec9bbb6fbb8cd41ec9d7c

import UIKit
import SVProgressHUD

class YBUserModel: NSObject, NSCoding {
    
    /// 单利
    private static var sharedInstance: YBUserModel?
    /// 归档地址
    private static let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/userData.plist"
    
    /// access_token
    var access_token: String?
    /// expires_in 生命周期
    var expires_in: NSTimeInterval {
        get{
            return date?.timeIntervalSinceNow ?? 0
        }set(newDate){
            // 讲数据转化成时间
            date = NSDate(timeIntervalSinceNow: newDate ?? 0)
        }
    }
    /// 保存access_token的过期时间
    private var date: NSDate?
    /// uid
    var uid: String?
    /// 是否登录
    var isLogin = false
    /// 用户昵称
    var screen_name: String?
    /// 头像地址
    var avatar_large: String?
    
    
    // MARK: - 构造方法
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    /// 防止KVC
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 加载网络数据获取登录信息
    class func loadUserLoginData(code: String,finish: (Bool) -> ()) {
        // 加载网络数据
        YBNetworking.sharedInstance.loadUserLoginData(code) { (result, error) -> () in
            // 判断是否成功
            if result != nil && error == nil {
                // 创建对象
                YBUserModel.sharedInstance = YBUserModel(dic: result!)
                // 设置已经登录
                YBUserModel.sharedInstance?.isLogin = true
                // 加载用户数据
                loadUserData()
                // 完成调用闭包
                finish(true)
            }else{
                finish(false)
            }
        }
    }
    
    /// 加载用户数据
    private class func loadUserData() {
        /// 加载用户数据
        YBNetworking.sharedInstance.loadUserData { (result, error) -> () in
            // 判断数据加载是都失败
            if result == nil && error != nil {
                // 数据加载失败
                SVProgressHUD.showErrorWithStatus("用户数据加载失败")
                return
            }
            YBUserModel.sharedInstance?.setValuesForKeysWithDictionary(result!)
            // 保存数据
            YBUserModel.sharedInstance!.saveData()
        }
    }
    
    /// 获取数据
    class func userModel() -> YBUserModel? {
        if YBUserModel.sharedInstance == nil {
            // 重缓存加载数据
            YBUserModel.sharedInstance = NSKeyedUnarchiver.unarchiveObjectWithFile(YBUserModel.path) as? YBUserModel
        }
        // 判断时间是否超时
        if NSDate().compare(sharedInstance?.date ?? NSDate()) == NSComparisonResult.OrderedDescending {
            // 表示超时(没有登录)
            YBUserModel.sharedInstance!.isLogin = false
        }
        return YBUserModel.sharedInstance
    }
    
    /// 保存数据
    private func saveData(){
        NSKeyedArchiver.archiveRootObject(self, toFile: YBUserModel.path)
    }
    
    /// 退出登录
    class func exitLogin(){
        YBUserModel.sharedInstance?.isLogin = false
        YBUserModel.sharedInstance?.saveData()
    }
    
    /// 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(uid, forKey: "uid")
        // 是否登录信息
        aCoder.encodeBool(isLogin, forKey: "isLogin")
        // 用户昵称
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        // 头像地址
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        date = aDecoder.decodeObjectForKey("date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        // 是否登录信息
        isLogin = aDecoder.decodeBoolForKey("isLogin")
        // 用户昵称
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        // 头像地址
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}












