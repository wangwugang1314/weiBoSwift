//
//  YBVisitView.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

// MARK: - 代理
protocol YBVisitViewDelegate: NSObjectProtocol {
    // 登录按钮点击
    func visitViewLoginButClick()
    // 注册按钮点击
    func visitViewRegisterButClick()
}

class YBVisitView: UIView {
    
    // MARK: - 属性
    /// 是否是主页
    var isVisit: Bool = false {
        didSet{
            // 设置房子是否隐藏
            houseImageView.hidden = !isVisit
            // 设置遮盖是否隐藏
            coverImageView.hidden = !isVisit
            // 如果是首页设置动画
            if isVisit {
                startAnmit()
            }
        }
    }
    
    /// 代理
    weak var ybDelegate: YBVisitViewDelegate?
    
    // MARK: -  构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置背景颜色
        backgroundColor = UIColor(white: 237 / 255, alpha: 1)
        // 准备UI
        prepareUI()
        // 设置通知
        visitViewNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 通知
    private func visitViewNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackgroundNotification", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForegroundNotification", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    /// 已经进入后台通知
    @objc private func didEnterBackgroundNotification(){
        // 移除动画
        centerImageView.layer.removeAllAnimations()
    }
    
    /// 将要进入前台通知
    @objc private func willEnterForegroundNotification(){
        startAnmit()
    }
    
    // 准备UI
    private func prepareUI(){
    
        // 中间图片
        addSubview(centerImageView)
        // 半透明遮盖
        addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        // 房子
        addSubview(houseImageView)
        // 说明文字
        addSubview(showTitleLable)
        showTitleLable.translatesAutoresizingMaskIntoConstraints = false
        // 登录
        addSubview(loginBut)
        loginBut.translatesAutoresizingMaskIntoConstraints = false
        // 注册
        addSubview(registerBut)
        registerBut.translatesAutoresizingMaskIntoConstraints = false
        
        // 约束中间图片
        centerImageView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: CGSize(width: 175, height: 175), offset: CGPoint(x: 0, y: -50))
        // 约束半透明遮盖
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[coverImageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["coverImageView" : coverImageView]))
        addConstraint(NSLayoutConstraint(item: coverImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: centerImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 30))
        // 约束房子
        houseImageView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: centerImageView, size: CGSize(width: 90, height: 90), offset: CGPoint(x: 0, y: -20))
        // 约束文字
        addConstraint(NSLayoutConstraint(item: showTitleLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() * 0.7))
        addConstraint(NSLayoutConstraint(item: showTitleLable, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: centerImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: showTitleLable, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: centerImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20))
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginBut, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -20))
        addConstraint(NSLayoutConstraint(item: loginBut, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: showTitleLable, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 30))
        addConstraint(NSLayoutConstraint(item: loginBut, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80))
        addConstraint(NSLayoutConstraint(item: loginBut, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerBut, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: registerBut, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: showTitleLable, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 30))
        addConstraint(NSLayoutConstraint(item: registerBut, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80))
        addConstraint(NSLayoutConstraint(item: registerBut, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40))
    }
    
    // MARK: - 动画
    private func startAnmit(){
        // 创建动画
        let animit = CABasicAnimation(keyPath: "transform.rotation")
        animit.toValue = 2 * M_PI
        // 设置动画时间
        animit.duration = 30
        // 设置循环次数
        animit.repeatCount = MAXFLOAT
        animit.removedOnCompletion = false
        // 添加动画
        self.centerImageView.layer.addAnimation(animit, forKey: nil)
    }
    
    // MARK: - 按钮点击方法
    @objc private func butClick(but: UIButton) {
        if but == loginBut {
            ybDelegate?.visitViewLoginButClick()
        }else if but == registerBut {
            ybDelegate?.visitViewRegisterButClick()
        }
    }

    // MARK: - 懒加载
    /// 中间图片
    lazy var centerImageView: UIImageView = UIImageView()
    
    /// 半透明遮盖
    private var coverImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    /// 小房子
    private lazy var houseImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 说明文字
    lazy var showTitleLable: UILabel = {
        let lable = UILabel()
        // 设置对齐方式
        lable.textAlignment = NSTextAlignment.Center
        // 设置文字颜色
        lable.textColor = UIColor.grayColor()
        // 设置多行显示
        lable.numberOfLines = 0
        // 设置透明度
        lable.alpha = 0.8
        return lable
    }()
    
    /// 登录按钮
    private lazy var loginBut: UIButton = {
        let but = UIButton()
        // 设置背景图片
        but.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        // 设置文字
        but.setTitle("登录", forState: UIControlState.Normal)
        // 设置颜色
        but.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        // 添加点击事件
        but.addTarget(self, action: "butClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
    /// 注册按钮
    private lazy var registerBut: UIButton = {
        let but = UIButton()
        // 设置背景图片
        but.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        // 设置文字
        but.setTitle("注册", forState: UIControlState.Normal)
        but.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        // 添加点击事件
        but.addTarget(self, action: "butClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
    /// 对象消除
    deinit{
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
