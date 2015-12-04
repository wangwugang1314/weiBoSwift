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
    var data: YBWeiBoModel? {
        didSet{
            // 顶部
            topView.data = data
            // 微薄文字内容
            textView.text = data?.text
            // 中间视图
            centerView.dataModel = data
            // 判断是都是转发微薄还有图片
            if data!.retweeted_status == nil && data?.imageURLs.count == 0 {
                centerView.hidden = true
                conBottom?.constant = -5;
            } else {
                centerView.hidden = false
                conBottom?.constant = 5
            }
            layoutIfNeeded()
            
            // 判断是都是转发微薄还有图片
            if data!.retweeted_status == nil && data?.imageURLs.count == 0 {
                data?.rowHeight = CGRectGetMaxY(textView.frame) + 44 + 10
            } else {
                data?.rowHeight = CGRectGetMaxY(centerView.frame) + 44 + 10
            }
        }
    }
    
    /// 底部试图约束
    private var conBottom: NSLayoutConstraint?
    
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
        contentView.addSubview(topView)
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.width(), height: 60))
        // 微薄文字内容
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: topView, attribute: .Bottom, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: UIScreen.width() - 20))
        // 中间视图
        contentView.addSubview(centerView)
        centerView.mas_makeConstraints { (make) -> Void in
            make.left.mas_equalTo()(self.contentView.mas_left)
            make.right.mas_equalTo()(self.contentView.mas_right)
            make.top.mas_equalTo()(self.textView.mas_bottom).offset()(5)
        }
        // 底部试图
        addSubview(bottomView)
        let con = bottomView.ff_AlignVertical(type: ff_AlignType.BottomRight, referView: centerView, size: CGSize(width: UIScreen.width(), height: 44), offset: CGPoint(x: 0, y: 5))
        conBottom = bottomView.ff_Constraint(con, attribute: NSLayoutAttribute.Top)
    }
    
    // MARK: - 懒加载
    /// 顶部试图
    private lazy var topView: YBHomeCellTopView = YBHomeCellTopView()
    
    /// 微薄内容
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.blackColor()
        view.numberOfLines = 0
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    /// 中间试图
    private lazy var centerView: YBHomeCellCenterView = {
        let view = YBHomeCellCenterView()
        
        return view
    }()
    
    /// 底部试图
    private lazy var bottomView: YBHomeCellBottomView = {
        let view = YBHomeCellBottomView()
        return view
    }()
}
