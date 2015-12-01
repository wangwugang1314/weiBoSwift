//
//  YBHomeTableViewCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeTableViewCell: UITableViewCell {

    // MARK: - 属性
    var data: YBWeiBoModel?
    
    // MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 顶部试图
        addSubview(topView)
        topView.ff_AlignInner(type: ff_AlignType.TopCenter, referView: contentView, size: CGSize(width: UIScreen.width(), height: 60))
    }
    
    // MARK: - 懒加载
    /// 顶部试图
    private lazy var topView: YBHomeCellTopView = YBHomeCellTopView()
}
