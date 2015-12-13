//
//  YBEmotionGroupView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

/// 代理通知点击了某个按钮
protocol YBEmotionGroupViewDelegate: NSObjectProtocol {
    
    /// 点击了某一行
    func emotionGroupView(emotionGroupView: YBEmotionGroupView, index: Int)
}

class YBEmotionGroupView: UIScrollView {

    // MARK: - 属性
    /// 代理
    weak var ybDelegate: YBEmotionGroupViewDelegate?
    
    /// 当前点击的按钮
    var selIndex: Int? {
        didSet {
            // 获取按钮
            let but = viewWithTag(selIndex! + 100) as? UIButton
            
            if but != nil {
                selBut(but!)
            }
        }
    }
    
    /// 当期只能选中的按钮
    private var selBut: UIButton?
    
    /// 数据
    var dataArr: [YBEmotionGroupModel]? {
        didSet {
            // 准备UI
            prepareUI()
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 弹簧效果
        alwaysBounceHorizontal = true
        backgroundColor = UIColor(white: 0, alpha: 0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置按钮宽度
        let butWidth = UIScreen.width() / CGFloat(dataArr!.count);
        // 遍历数组
        for index in 0..<dataArr!.count {
            // 创建but
            let but = UIButton(frame: CGRect(x: butWidth * CGFloat(index), y: 0, width: butWidth, height: 44))
            // 设置数据
            but.setTitle(dataArr![index].groupName, forState: UIControlState.Normal)
            // 添加
            addSubview(but)
            // 设置点击方法
            but.addTarget(self, action: "butClick:", forControlEvents: UIControlEvents.TouchUpInside)
            // 设置选中背景
            but.setBackgroundImage(UIImage(named: "QQ20151212-0"), forState: UIControlState.Selected)
            // 设置选中字体颜色
            but.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Selected)
            // 设置tag
            but.tag = index + 100;
            // 默认选中第二个
            if index == 1 {
                selBut(but)
            }
        }
        
        selIndex = 1000
    }
    
    // MARK: - 按钮点击方法
    @objc private func butClick(but: UIButton){
        // 如果当前按钮与上一个按钮相同直接返回
        if but == selBut {return}
        
        selBut(but)
        // 代理
        ybDelegate?.emotionGroupView(self, index: but.tag - 100)
    }
    
    // 选择按钮
    private func selBut(but: UIButton) {
        // 取消选中之前的
        selBut?.selected = false
        // 记录
        selBut = but;
        // 选中当前
        but.selected = true
    }
}
