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
    }
    
    // MARK: - 懒加载
}
