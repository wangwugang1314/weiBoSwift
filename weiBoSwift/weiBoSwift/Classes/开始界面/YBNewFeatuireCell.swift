//
//  YBNewFeatuireCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBNewFeatuireCell: UICollectionViewCell {

    // MARK: - 属性
    /// 索引
    var index: Int = 0 {
        didSet {
            bgView.image = UIImage(named: "new_feature_\(index + 1)")
        }
    }
    /// 是否显示按钮
    var isShowBut: Bool {
        get{
            return true
        }set(newValue){
            startBut.hidden = !newValue
            // 设置动画
            startBut.transform = CGAffineTransformMakeScale(0.01, 0.01)
            UIView.animateWithDuration(2, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 4, options: UIViewAnimationOptions(rawValue: 2), animations: { () -> Void in
                    self.startBut.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    
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
        // 背景试图
        addSubview(bgView)
        bgView.ff_Fill(contentView)
        // 开始按钮
        addSubview(startBut)
        startBut.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: contentView, size: CGSize(width: 105, height: 36), offset: CGPoint(x: 0, y: -180))
    }
    
    // MARK: - 按钮点击事件
    @objc private func startButClick(){
        print("开始按钮点击")
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgView: UIImageView = UIImageView()
        
    /// 开始按钮
    private lazy var startBut: UIButton = {
        let but = UIButton()
        but.setTitle("开始", forState: UIControlState.Normal)
        but.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        but.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        but.hidden = true
        // 添加点击事件
        but.addTarget(self, action: "startButClick", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
}
