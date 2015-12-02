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
        }
    }
    
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
    }
    
    // MARK: - 懒加载
    /// 顶部试图
    private lazy var topView: YBHomeCellTopView = YBHomeCellTopView()
    /// 微薄内容
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.blackColor()
        view.font = UIFont.systemFontOfSize(18)
        view.numberOfLines = 0
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
}
