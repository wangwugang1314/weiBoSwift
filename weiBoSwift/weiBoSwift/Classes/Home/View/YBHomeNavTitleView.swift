//
//  YBHomeNavTitleView.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeNavTitleView: UIButton {
    
    // MARK: - 属性
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置数据
        setTitle(YBUserModel.userModel()?.screen_name, forState: UIControlState.Normal)
        setTitleColor(UIColor.orangeColor(), forState: .Normal)
        setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        selected = true
        sizeToFit()
    }
    
    // 重写属性
    override var selected: Bool {
        didSet(newValue){
            setImage(UIImage(named: newValue ? "navigationbar_arrow_down" : "navigationbar_arrow_up"), forState: .Normal)
        }
    }
    
    // MARK: - 布局子试图
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.X = 0
        imageView?.X = titleLabel!.width + 3
    }
}
