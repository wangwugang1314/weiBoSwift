//
//  YBSendImageViewCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

/// 代理
protocol YBSendImageViewCellDelegate: NSObjectProtocol {
    
    /// 点击删除按钮执行
    func clickDelButWithSendImageViewCell(cell: YBSendImageViewCell)
}

class YBSendImageViewCell: UICollectionViewCell {
    
    // MARK: - 属性
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    /// 代理
    var ybDelegate: YBSendImageViewCellDelegate?
    
    /// 是否隐藏删除按钮
    var isHiddenDelBut = false {
        didSet {
            delView.hidden = isHiddenDelBut
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
        // 图片试图
        contentView.addSubview(imageView)
        imageView.ff_Fill(contentView)
        // 删除按钮
        contentView.addSubview(delView)
        delView.ff_AlignInner(type: ff_AlignType.TopRight, referView: contentView, size: CGSize(width: 30, height: 30))
    }
    
    // MARK: - 按钮点击方法
    @objc private func delButClick(){
        ybDelegate?.clickDelButWithSendImageViewCell(self)                               
    }
    
    // MARK: - 懒加载
    /// 图片试图 UIViewContentModeScaleAspectFill
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// 删除按钮
    private lazy var delView: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "aio_live_button_pressed"), forState: .Normal)
        but.addTarget(self, action: "delButClick", forControlEvents: .TouchUpInside)
        return but
    }()
}
