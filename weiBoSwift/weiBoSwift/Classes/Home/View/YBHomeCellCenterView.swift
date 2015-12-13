//
//  YBHomeCellCenterView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeCellCenterView: UIView {

    // MARK: - 属性
    var dataModel: YBWeiBoModel? {
        didSet {
            // 设置图片数据
            collectionView.dataModel = dataModel
            // 判断是不是转发微薄
            if let retween = dataModel?.retweeted_status { // 转发微薄
                let ret = retween as! YBWeiBoModel
                // 设置textView
                textView.text = ret.text
                constraintTop?.constant = 5
                backgroundColor = UIColor(white: 0, alpha: 0.1)
            }else{ // 原创微薄
                textView.text = ""
                constraintTop?.constant = 0
                backgroundColor = UIColor.whiteColor()
            }
            let collSize = collectionView.countCollectionSize()
            // 设置collectionView大小
            constraintW?.constant = collSize.width
            constraintH?.constant = collSize.height
            constraintViewBottom?.constant = dataModel?.imageURLs.count == 0 ? 0 : 5
        }
    }
    
    /// 约束
    /// collection的约束
    var constraintW: NSLayoutConstraint?
    var constraintH: NSLayoutConstraint?
    var constraintTop: NSLayoutConstraint?
    /// self的约束
    var constraintViewBottom: NSLayoutConstraint?
    
    // MARK: - 构造方法
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
        // 文本视图
        addSubview(textView)
        textView.mas_makeConstraints { (mask) -> Void in
            mask.top.mas_equalTo()(self.mas_top).offset()(5)
            mask.left.mas_equalTo()(self.mas_left).offset()(5)
            mask.width.mas_equalTo()(UIScreen.width() - 20)
        }
        // 图片
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 10))
        constraintW = NSLayoutConstraint(item: collectionView, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        constraintH = NSLayoutConstraint(item: collectionView, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        constraintTop = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: NSLayoutRelation.Equal, toItem: textView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        // 底边
        constraintViewBottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: collectionView, attribute: .Bottom, multiplier: 1, constant: 5)
        addConstraints([constraintW!, constraintH!, constraintTop!, constraintViewBottom!])
        // 底边
    }
    
    // MARK: - 懒加载
    /// 文本
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFontOfSize(16)
        return view
    }()
    
    /// 图片
    private lazy var collectionView: YBHomeCellImageCollectionView = {
        let view = YBHomeCellImageCollectionView()
        
        return view
    }()
}
