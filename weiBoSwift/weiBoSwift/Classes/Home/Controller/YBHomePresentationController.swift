//
//  YBHomePresentationController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/30.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomePresentationController: UIPresentationController {

    /// 将要布局的时候调用
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        coverView.frame = containerView!.bounds
        containerView?.insertSubview(coverView, belowSubview: presentedView()!)
        // 设置锚点
        presentedView()?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        // 设置展现试图的大小
        presentedView()?.frame = CGRectMake(90, 60, 200, 300)
    }
    
    /// 将要展现的时候调用
    override func presentationTransitionWillBegin() {
        // 添加手势(点击手势)
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapGestureRecognizer"))
    }
    
    /// 添加手势方法
    @objc private func tapGestureRecognizer(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var coverView: UIView = {
        let view = UIView()
        view.alpha = 0.5
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
}
