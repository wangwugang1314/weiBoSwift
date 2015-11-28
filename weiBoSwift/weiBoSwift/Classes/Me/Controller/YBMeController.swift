//
//  YBMeController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBMeController: YBBaseTableViewController {

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 准备UI
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "退出登录", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemClick")
    }
    
    // MARK: - 按钮点击事件
    @objc private func rightBarButtonItemClick(){
        YBUserModel.exitLogin()
        UIApplication.sharedApplication().keyWindow?.rootViewController = YBTabBarController()
    }
}
