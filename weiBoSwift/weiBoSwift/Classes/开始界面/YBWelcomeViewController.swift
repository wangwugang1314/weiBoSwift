//
//  YBWelcomeViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/28.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBWelcomeViewController: UIViewController {

    // MARK: - 属性
    /// 头像底部约束
    private var constent: NSLayoutConstraint?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 准备UI
        prepareUI()
        // 动画
        iconAnimation()
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(userName)
        // 背景
        bgImageView.ff_Fill(view)
        // 头像
        let con = iconView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSize(width: 85, height: 85), offset: CGPoint(x: 0, y: -30))
        constent = iconView.ff_Constraint(con, attribute: NSLayoutAttribute.Bottom)
        // 名称
        userName.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
        
        view.layoutIfNeeded()
    }
    
    // MARK: - 动画
    private func iconAnimation(){
        constent?.constant = -view.height * 0.8
        UIView.animateWithDuration(2.2, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.userName.alpha = 1
                    }, completion: { (_) -> Void in
                        // 完成控制器跳转
                })
        }
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    /// 头像
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = 42.5
        return iconView
    }()
    
    /// 名称
    private lazy var userName: UILabel = {
        let lable = UILabel()
        lable.text = "焚膏继晷"
        lable.textColor = UIColor.orangeColor()
        lable.font = UIFont.systemFontOfSize(20)
        lable.alpha = 0
        return lable
    }()
}









