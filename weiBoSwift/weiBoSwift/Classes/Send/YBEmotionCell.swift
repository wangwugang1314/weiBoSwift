//
//  YBEmotionCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBEmotionCell: UICollectionViewCell {
    
    // MARK: - 属性
    /// 数据
    var dataModel:YBEmotionModel? {
        didSet {
            contentBut.setTitle(nil, forState: UIControlState.Normal)
            contentBut.setImage(nil, forState: UIControlState.Normal)
            // 判断数据的类型
            if dataModel!.code != nil { // emoji表情
                contentBut.setTitle(dataModel!.code!, forState: UIControlState.Normal)
            } else if dataModel?.png != nil {
                contentBut.setImage(UIImage(named: dataModel!.png!), forState: UIControlState.Normal)
            } else if dataModel?.deleteStr != nil {
                contentBut.setImage(UIImage(named: dataModel!.deleteStr!), forState: UIControlState.Normal)
            }
        }
    }
    
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
        // 按钮
        addSubview(contentBut)
        contentBut.ff_Fill(contentView)
    }
    
    // MARK: - 懒加载
    /// 按钮
    private lazy var contentBut: UIButton = {
        let but = UIButton()
        // 不与用户交互
        but.userInteractionEnabled = false
        but.titleLabel?.font = UIFont.systemFontOfSize(34)
        return but
    }()
}
