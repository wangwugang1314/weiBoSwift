//
//  YBNetworking.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/27.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import AFNetworking

/// 返回参数
typealias YBNetworkingFinish = (result: [String: AnyObject]?, error: NSError?) -> ()

class YBNetworking: NSObject {
    
    // MARK: - 属性
    /// 单利
    static let sharedInstance = YBNetworking()
    /// AppKey
    static let client_id = "4261273397"
    /// App Secret
    static let client_secret = "dc7e5074eccc1314683566033e684729"
    /// 回调地址
    static let redirect_uri = "https://www.baidu.com/"
    
    // MARK: - 加载微博数据
    func loadWeiBoData(newData: Int ,max_id:Int ,finish: (result: [[String: AnyObject]]?, error: NSError?) -> ()) {
        let path = "/2/statuses/home_timeline.json"
        let dic = ["access_token": YBUserModel.userModel()!.access_token!, "since_id": newData, "max_id": max_id];
        // 加载数据
        GET(path, parameters: dic as? [String : AnyObject]) { (result, error) -> () in
            finish(result: result?["statuses"] as? [[String: AnyObject]], error: error)
        }
    }
    
    // MARK: - 加载用户信息
    /// 加载用户登录信息
    func loadUserLoginData(code: String, finish: YBNetworkingFinish) {
        let path = "/oauth2/access_token"
        let dic = ["client_id": YBNetworking.client_id,
               "client_secret": YBNetworking.client_secret,
                  "grant_type": "authorization_code",
                        "code": code,
                "redirect_uri": YBNetworking.redirect_uri]
        // 加载网络数据
        POST(path, parameters: dic) { (result, error) -> () in
            finish(result: result, error: error)
        }
    }
    
    /// 加载用户信息
    func loadUserData(finish: YBNetworkingFinish){
        let path = "/2/users/show.json"
        let dic = ["access_token": YBUserModel.userModel()!.access_token!, "uid": YBUserModel.userModel()!.uid!]
        
        // 加载网络数据
        GET(path, parameters: dic as [String: AnyObject]) { (result, error) -> () in
            finish(result: result, error: error)
        }
    }
    
    // MARK: - 封装网络请求
    /// 封装POST
    private func POST(URLString: String, parameters: [String: AnyObject]?, finish: YBNetworkingFinish) {
        // POST请求
        netManager.POST(URLString, parameters: parameters, success: { (_, data) -> Void in
            // 成功调用
            finish(result: data as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
                // 失败调用
                finish(result: nil, error: error)
        }
    }
    
    /// 封装GET
    private func GET(URLString: String, parameters: [String: AnyObject]?, finish: YBNetworkingFinish) {
        // GET请求
        netManager.GET(URLString, parameters: parameters, success: { (_, data) -> Void in
            // 成功调用
            finish(result: data as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
                // 失败调用
                finish(result: nil, error: error)
        }
    }
    
    // MAEK: - 懒加载
    /// 网络工具
    private let netManager: AFHTTPSessionManager = {
        // 创建并设置baseURL
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "https://api.weibo.com/"))
        // 添加解析类型
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return manager
    }()
}
