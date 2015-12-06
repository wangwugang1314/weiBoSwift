//
//  YBBaseTableViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/25.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBBaseTableViewController: UITableViewController {
    
    // MARK: - 属性
    /// 是否已经登录
    private var isVisit = YBUserModel.userModel()?.isLogin ?? false
    /// loadView
    override func loadView() {
        isVisit ? super.loadView() : visitView()
    }

    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isVisit {
            // 设置登录按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButClick")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerButClick")
        }else{
            // 设置颜色
            view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // MARK: - 按钮点击
    /// 登录按钮点击
    @objc private func loginButClick(){
        print("登录按钮点击")
        // 跳转到授权界面
        let navC = UINavigationController(rootViewController: YBLoginViewController())
        presentViewController(navC, animated: true, completion: nil)
    }
    
    /// 注册按钮点击
    @objc private func registerButClick() {
        print("注册按钮点击")
    }

    // MARK: - 访客试图
    private func visitView() {
        view = YBVisitView()
        
        // 设置访客内容
        switch self {
        case is YBHomeController:
            setVisitContent("visitordiscover_feed_image_smallicon", isHome: true, title: "关注一些人,看看有上面惊喜")
        case is YBMessageController:
            setVisitContent("visitordiscover_image_message", isHome: false, title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        case is YBDiscoverController:
            setVisitContent("visitordiscover_image_message", isHome: false, title: "录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        case is YBMeController:
            setVisitContent("visitordiscover_image_profile", isHome: false, title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        default : break
        }
        
    }
    
    /// 设置内容
    private func setVisitContent(centerImageName: String, isHome: Bool, title: String) {
        
        let visitView = view as! YBVisitView
        // 设置代理
        visitView.ybDelegate = self
        // 设置中间图片
        visitView.centerImageView.image = UIImage(named: centerImageName)
        // 设置房子
        visitView.isVisit = isHome;
        // 设置文字
        visitView.showTitleLable.text = title
    }
    
    /// 对象销毁
//    deinit {
//        print(self)
//    }
}

// MARK: - 扩展
extension YBBaseTableViewController: YBVisitViewDelegate {
    
    /// 按钮点击代理
    func visitViewLoginButClick() {
        loginButClick()
    }
    
    func visitViewRegisterButClick() {
        registerButClick()
    }
}











