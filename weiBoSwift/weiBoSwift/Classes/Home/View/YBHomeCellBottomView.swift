//
//  YBHomeCellBottomView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeCellBottomView: UIView {

    // MARK: - 属性
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 准备UI
        prepareUI()
        
        backgroundColor = UIColor.lightGrayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        addSubview(retweetView)
        addSubview(commentView)
        addSubview(unlikeView)
        
        self.ff_HorizontalTile([retweetView, commentView, unlikeView], insets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
    }
    
    // MARK: - 懒加载
    /// 转发
    private lazy var retweetView: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        but.setTitle("转发", forState: UIControlState.Normal)
        but.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        but.backgroundColor = UIColor.whiteColor()
        return but
    }()
    
    /// 评论
    private lazy var commentView: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "timeline_icon_comment"), forState: UIControlState.Normal)
        but.setTitle("评论", forState: UIControlState.Normal)
        but.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        but.backgroundColor = UIColor.whiteColor()
        return but
    }()
    
    /// 赞
    private lazy var unlikeView: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        but.setTitle("赞", forState: UIControlState.Normal)
        but.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        but.backgroundColor = UIColor.whiteColor()
        return but
    }()
}
