//
//  YBHomeWebViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/8.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeWebViewController: UIViewController {
    
    // MARK: - 属性
    /// webView
    private let webView = UIWebView()
    
    // MARK: - loadView
    override func loadView() {
        view = webView
    }
    
    // MARK: - 构造函数
    init(pathStr: String) {
        super.init(nibName: nil, bundle: nil)
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: pathStr)!))
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
    }
    
    // MARK: - 按钮点击方法
    @objc private func leftBarButtonItemClick(){
        // 退出
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载

}
