//
//  YBSendTextView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBSendTextView: UITextView {

    // MARK: - 属性
    // MARK: - 构造函数
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // 设置字体大小
        font = UIFont.systemFontOfSize(20)
        // 设置可以滚动
        alwaysBounceVertical = true
        // 代理
        delegate = self;
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 占位文本
        addSubview(placeholderView)
        placeholderView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: 5, y: 8))
        // 图片
        addSubview(imageCollectionView)
        let itemWith = (UIScreen.width() - 40) / 3
        imageCollectionView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.width() - 20, height: itemWith * 2 + 10), offset: CGPoint(x: 10, y: 150))
    }
    
    // MARK: - 懒加载
    /// 占位文本
    private lazy var placeholderView: UILabel = {
        let view = UILabel()
        view.text = "分享新鲜事..."
        view.textColor = UIColor.lightGrayColor()
        view.sizeToFit()
        view.font = self.font
        return view
    }()
    
    /// 图片
    lazy var imageCollectionView: YBSendImageView = {
        let view = YBSendImageView()
        return view
    }()
}

/// 代理
extension YBSendTextView: UITextViewDelegate {
    
    /// 滚动调用
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 迟去第一响应者
        resignFirstResponder()
    }
    
    // 改变文字改变调用
    func textViewDidChange(textView: UITextView) {
        placeholderView.hidden = text.characters.count > 0
    }
}