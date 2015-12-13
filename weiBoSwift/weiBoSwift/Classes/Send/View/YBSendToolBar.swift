//
//  YBSendToolBar.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

// 工具条点击状态
public enum YBSendToolBarStatus : Int {
    
    case Emotion    // 表情
    case Keyboard   // 键盘
    case Picture    // 图片
}

/// 自定义代理
protocol YBSendToolBarDelegate: NSObjectProtocol {

    /// 工具条点击代理
    func sendToolBar(toolBar: YBSendToolBar, clickStatus: YBSendToolBarStatus)
}

class YBSendToolBar: UIToolbar {

    // MARK: - 属性
    /// 键盘状态 表情 true 文字 false
    private var keyboardStatus: Bool = false
    /// 代理
    weak var ybDelegate: YBSendToolBarDelegate?
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundColor = UIColor.orangeColor()
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        addSubview(pictureView)
        addSubview(mentionView)
        addSubview(trendView)
        addSubview(emoticonView)
        addSubview(addView)
        self.ff_HorizontalTile([pictureView, mentionView, trendView, emoticonView, addView], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 按钮点击
    /// 表情按钮点击
    @objc private func emoticonViewClick(){
        keyboardStatus = !keyboardStatus;
        // 代理
        ybDelegate?.sendToolBar(self, clickStatus: keyboardStatus ? .Emotion : .Keyboard)
        emoticonView.setImage(UIImage(named: keyboardStatus ? "compose_keyboardbutton_background" : "compose_emoticonbutton_background"), forState: UIControlState.Normal)
    }
    
    @objc private func pictureViewClick(){
        ybDelegate?.sendToolBar(self, clickStatus: .Picture)
    }
    
    // MARK: - 懒加载
    /// 图片
    private lazy var pictureView: UIButton = {
        let but = UIButton()
        // 设置图片
        but.setImage(UIImage(named: "compose_toolbar_picture"), forState: UIControlState.Normal)
        but.addTarget(self, action: "pictureViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
    /// @
    private lazy var mentionView: UIButton = {
        let but = UIButton()
        // 设置图片
        but.setImage(UIImage(named: "compose_mentionbutton_background"), forState: UIControlState.Normal)
        return but
    }()
    
    /// #
    private lazy var trendView: UIButton = {
        let but = UIButton()
        // 设置图片
        but.setImage(UIImage(named: "compose_trendbutton_background"), forState: UIControlState.Normal)
        return but
    }()
    
    /// 表情
    private lazy var emoticonView: UIButton = {
        let but = UIButton()
        // 设置图片
        but.setImage(UIImage(named: "compose_emoticonbutton_background"), forState: UIControlState.Normal)
        but.addTarget(self, action: "emoticonViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
    /// +
    private lazy var addView: UIButton = {
        let but = UIButton()
        // 设置图片
        but.setTitle("+", forState: UIControlState.Normal)
        but.titleLabel?.font = UIFont.systemFontOfSize(40)
        but.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        but.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        return but
    }()
    
    
    deinit {
        
    }
}
