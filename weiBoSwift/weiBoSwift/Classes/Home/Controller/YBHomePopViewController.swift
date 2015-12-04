//
//  YBHomePopViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/30.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomePopViewController: UIViewController {
    
    // MARK: - 属性
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 准备UI
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 背景试图
        view.addSubview(bgView)
        bgView.ff_Fill(view)
        
        addChildViewController(popTableViewC)
        view.addSubview(popTableViewC.view)
        popTableViewC.view.ff_Fill(view, insets: UIEdgeInsets(top: 11, left: 5, bottom: 7, right: 5))
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgView: UIImageView = UIImageView(image: UIImage(named: "popover_background"))
    
    /// tableView
    private lazy var popTableViewC: YBHomePopTableView = {
        let popTableView = YBHomePopTableView()
        return popTableView;
    }()

    /// 对象销毁
    deinit {
        print("popView销毁")
    }
}
