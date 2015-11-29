//
//  YBHomeController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeController: YBBaseTableViewController {

    // MARK: - 属性
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 准备UI
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置导航栏
        setNavigationBar()
        
    }
    
    /// 设置导航栏
    private func setNavigationBar(){
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendsearch"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemClick")
        // 中间
        navigationItem.titleView = titleView
    }
    
    // MARK: - 按钮点击
    /// 导航栏左边按钮点击
    @objc private func leftBarButtonItemClick(){
        print("导航栏左边按钮点击\(self)")
    }
    
    /// 导航栏右边按钮点击
    @objc private func rightBarButtonItemClick(){
        print("导航栏右边按钮点击\(self)")
    }
    
    /// 导航栏中间按钮点击
    @objc private func titleViewClick(){
        print("导航栏中间按钮点击\(self)")
    }
    
    // MARK: - 懒加载
    /// 导航栏中间按钮
    private lazy var titleView: YBHomeNavTitleView = {
        let titleView = YBHomeNavTitleView()
        // 添加点击事件
        titleView.addTarget(self, action: "titleViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return titleView
    }()
}



























