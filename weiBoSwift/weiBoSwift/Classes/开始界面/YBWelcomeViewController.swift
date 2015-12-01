//
//  YBWelcomeViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/28.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SDWebImage

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
        UIView.animateWithDuration(0.1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.userName.alpha = 1
                    }, completion: { (_) -> Void in
                        // 完成控制器跳转
                        UIApplication.sharedApplication().keyWindow?.rootViewController = YBTabBarController()
                })
        }
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    /// 头像
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.sd_setImageWithURL(NSURL(string: YBUserModel.userModel()?.avatar_large ?? ""),
            placeholderImage: UIImage(named: "avatar_default_big"))
        iconView.cornerRadius = 42.5
        return iconView
    }()
    
    /// 名称
    private lazy var userName: UILabel = {
        let lable = UILabel()
        lable.text = YBUserModel.userModel()?.screen_name
        lable.textColor = UIColor.orangeColor()
        lable.font = UIFont.systemFontOfSize(20)
        lable.alpha = 0
        return lable
    }()
    
    // 对象销毁
    deinit{
        print("\(self) - 销毁")
    }
}









