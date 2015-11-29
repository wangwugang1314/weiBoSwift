//
//  YBLoginViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/27.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class YBLoginViewController: UIViewController {
    
    // MARK: - 属性
    
    
    // MARK: - 初始化
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载网页
        loadWebView()
        // 设置导航栏按钮
        setNavigationBar()
        // 提示正在加载
        SVProgressHUD.showWithStatus("正在加载...", maskType: SVProgressHUDMaskType.None)
    }
    
    // MARK: - 准备UI
    /// 设置导航栏按钮
    private func setNavigationBar(){
        // 设置左边导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
        // 导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemClick")
    }
    
    /// 加载网页
    private func loadWebView(){
        // 加载网页
        let path = "https://api.weibo.com/oauth2/authorize?client_id=\(YBNetworking.client_id)&redirect_uri=\(YBNetworking.redirect_uri)"
        webView.loadRequest(NSURLRequest(URL: NSURL(string: path)!))
    }
    
    // MARK: - 按钮点击
    /// 导航栏左边按钮点击
    @objc private func leftBarButtonItemClick(){
        // 取消登录提示
        SVProgressHUD.dismiss()
        // 返回按钮退出
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 导航栏右边按钮点击
    @objc private func rightBarButtonItemClick(){
        let js = "document.getElementById('userId').value='15107780400';" + "document.getElementById('passwd').value='w123456';"
        
        // webView执行js代码
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    
    // MARK: - 懒加载
    /// webView
    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        // 设置代理
        webView.delegate = self
        return webView
    }()
    
    /// 对象销毁
    deinit {
        print("登录页面销毁")
    }
}

// MARK: - 扩展
extension YBLoginViewController: UIWebViewDelegate {
    
    /// 开始加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 获取URLString
        let path = request.URL?.absoluteString
        if let p = path {
            // 如果前缀是回调网址表示成功
            if p.hasPrefix(YBNetworking.redirect_uri) {
                // 获取code
                let code = (p as NSString).componentsSeparatedByString("=").last!
                // 加载数据
                YBUserModel.loadUserData(code, finish: { (isSuccess) -> () in
                    // 判断登录是否成功
                    if isSuccess { // 成功
                        SVProgressHUD.showSuccessWithStatus("登录成功")
                        // 欢迎界面
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            UIApplication.sharedApplication().keyWindow?.rootViewController = YBWelcomeViewController()
                        })
                    } else { // 失败
                        SVProgressHUD.showSuccessWithStatus("登录失败")
                    }
                })
                
                return false
            }
        }
        return true
    }
    
    /// 加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        // 清除登录页面
        SVProgressHUD.dismiss()
    }
}





















