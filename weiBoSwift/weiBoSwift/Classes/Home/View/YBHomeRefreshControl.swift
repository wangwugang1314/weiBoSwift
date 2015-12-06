//
//  YBHomeRefreshControl.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/6.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

/// 状态没记
public enum YBHomeRefreshControlStart : Int {
    
    case down       // 箭头向下
    case up         // 箭头向上
    case animation  // 动画
}

class YBHomeRefreshControl: UIRefreshControl {

    // MARK: - 属性
    // MARK: - 构造函数
    override init() {
        super.init()
        tintColor = UIColor.clearColor()
        // 准备UI
        prepareUI()
    }
    
    /// 设置当前状态
    var status = YBHomeRefreshControlStart.down {
        willSet(newValue){
            switch newValue {
            
            case YBHomeRefreshControlStart.down :
                setRefreshControlStartDown()
            case .up :
                setRefreshControlStartUp()
            case .animation :
                setRefreshControlStartAnimation()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 图片
        addSubview(imageView)
        imageView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: CGSize(width: 32, height: 32), offset: CGPoint(x: -40, y: 0))
        // 标题
        addSubview(titleView)
        titleView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: CGSize(width: 132, height: 32), offset: CGPoint(x: 50, y: 0))
    }
    
    // MARK: - 设置转换
    private func setRefreshControlStartUp(){
        // 旋转图片
        UIView.animateWithDuration(0.25, animations: {[unowned self] () -> Void in
            self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(-(M_PI - 0.01)))
        })
        // 设置文字
        titleView.text = "释放更新"
    }
    
    private func setRefreshControlStartDown(){
        // 判断上一次状态
        if status == .animation {
            // 移除动画
            imageView.layer.removeAllAnimations()
            // 设置文字
            titleView.text = "下拉刷新"
            // 设置图片
            imageView.image = UIImage(named: "tableview_pull_refresh")
            self.imageView.transform = CGAffineTransformIdentity;
        } else if status == .up {
            // 设置文字
            titleView.text = "下拉刷新"
            // 设置动画
            UIView.animateWithDuration(0.25, animations: {[unowned self] () -> Void in
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private func setRefreshControlStartAnimation(){
        // 如果上一次是动画直接返回
        if status == .animation {
            return
        }
        // 设置文字
        titleView.text = "加载中..."
        // 设置图片
        imageView.image = UIImage(named: "tableview_loading")
        // 设置动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        imageView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK: - 懒加载
    /// 标题
    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.grayColor()
        view.text = "下拉刷新"
        return view
    }()
    
    /// 图片
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tableview_pull_refresh")
        return view
    }()
}
