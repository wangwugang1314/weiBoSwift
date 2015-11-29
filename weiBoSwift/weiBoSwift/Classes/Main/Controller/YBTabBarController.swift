//
//  YBTabBarController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/25.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBTabBarController: UITabBarController {
    
    //MARK: - 属性animated

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 准备UI
        prepareUI()
        // 设置渲染颜色
        tabBar.tintColor = UIColor.orangeColor()
        // 设置背景颜色
        tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "tabbar_background")!)
    }
    
    /// 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 添加中间按钮
        addCenterBut()
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 首页
        creatController(YBHomeController(), title: "首页", imageName: "tabbar_home")
        // 消息
        creatController(YBMessageController(), title: "消息", imageName: "tabbar_message_center")
        // 占位
        creatController(UIViewController(), title: "", imageName: "")
        // 发现
        creatController(YBDiscoverController(), title: "发现", imageName: "tabbar_discover")
        // 我
        creatController(YBMeController(), title: "我", imageName: "tabbar_profile")
    }
    
    /// 添加中间按钮
    private func addCenterBut(){
        // 创建按钮
        let but = UIButton(frame: CGRect(x: UIScreen.width() * 0.4, y: 0, width: UIScreen.width() * 0.2 + 2, height: tabBar.height))
        // 设置背景图片
        but.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        but.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        but.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        but.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        // 添加
        tabBar.addSubview(but)
        // 设置点击事件
        but.addTarget(self, action: "centerButClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 中间按钮点击事件
    @objc private func centerButClick(){
        print("中间按钮点击")
    }
    
    /// 根据指定的名称图片穿件控制器
    private func creatController(controller: UIViewController, title: String?, imageName: String?) {

        // 创建导航控制器
        let navC = YBBaseNavigationController(rootViewController: controller)
        
        if title?.characters.count > 0 {
            navC.tabBarItem.title = title
            navC.tabBarItem.setTitleTextAttributes([NSUnderlineStyleAttributeName : 1], forState: UIControlState.Normal)
            // 设置图片
            navC.tabBarItem.image = UIImage(named: imageName!)
        }
        // 添加到tabBar控制器
        addChildViewController(navC)
    }
    
    // 对象销毁
//    deinit{
//        print("\(self) - 销毁")
//    }
}
