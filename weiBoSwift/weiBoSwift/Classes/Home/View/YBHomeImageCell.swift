//
//  YBHomeImageCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeImageCell: UICollectionViewCell {

    // MARK: - 属性
    var dataUrl: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(dataUrl, placeholderImage: UIImage(named: "sys_qq_1"))
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
        imageView.ff_Fill(self.contentView)
    }
    
    // MARK: - 懒加载
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = UIViewContentMode.ScaleAspectFill
        view.clipsToBounds = true
        return view
    }()
}
