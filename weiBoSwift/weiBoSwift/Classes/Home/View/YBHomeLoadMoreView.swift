//
//  YBHomeLoadMoreView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/6.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeLoadMoreView: UIView {

    // MARK: - 属性
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: 44))
        // 准备UI
        prepareUI()
        backgroundColor = UIColor.grayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 菊花指示器
        addSubview(activityIndicatorView)
        activityIndicatorView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPoint(x: -60, y: 0))
        // 标题
        addSubview(titleView)
        titleView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: CGSize(width: 130, height: 30), offset: CGPoint(x: 40, y: 0))
        
    }
    
    // MARK: - 懒加载
    /// 菊花指示器
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        view.startAnimating()
        return view
    }()
    
    /// 标题
    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.orangeColor()
        view.text = "正在加载..."
        return view;
    }()
}
