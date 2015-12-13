//
//  YBHomePictureCell.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD


protocol YBHomePictureCellDelegate: NSObjectProtocol {
    
    /// 通知控制器管理图片查看器
    func dismisspWithPictureCell(cell: YBHomePictureCell)
}

// 最小缩放比例
let YBHomeImageScrollViewMinScale: CGFloat = 0.6

class YBHomePictureCell: UICollectionViewCell {

    // MARK: - 属性
    var imageUrl: NSURL? {
        didSet {
            pictureView.transform = CGAffineTransformIdentity
            scrollView.contentInset = UIEdgeInsetsZero
            scrollView.contentOffset = CGPointZero
            scrollView.contentSize = CGSizeZero
            pictureView.hidden = true
            // 加载图片
            pictureView.sd_setImageWithURL(imageUrl) { [unowned self] (image, error, _, _) -> Void in
                self.pictureView.image = image
                SVProgressHUD.dismiss()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pictureView.frame = CGRectMake(0, 0, UIScreen.width(), image.size.height * (UIScreen.width() / image.size.width))
                    self.scrollView.contentInset = UIEdgeInsets(top: (self.scrollView.viewHeight - self.pictureView.viewHeight) * 0.5, left: 0, bottom: 0, right: 0)
                    self.pictureView.hidden = false
                    // 如果图片太大滚动到最上面
                    if self.pictureView.viewHeight > UIScreen.height() {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                        self.scrollViewDidZoom(self.scrollView)
                        self.scrollView.contentSize = self.pictureView.viewSize
                    }
                })
            }
        }
    }
    
    /// 代理
    weak var ybDelegate: YBHomePictureCellDelegate?
    
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
        // scrollView
        contentView.addSubview(scrollView)
        scrollView.ff_Fill(contentView, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        // imageView
        scrollView.addSubview(pictureView)
        
    }
    
    // MARK: - 懒加载
    /// scrollView
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.minimumZoomScale = YBHomeImageScrollViewMinScale
        view.maximumZoomScale = 2
        view.delegate = self;
        return view
    }()
    
    /// imageView
    lazy var pictureView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    
    
}

extension YBHomePictureCell: UIScrollViewDelegate {
    
    /// 设置要缩放的试图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pictureView;
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // 如果缩放比例小于3就自动回去
        if scrollView.zoomScale <= 0.6 {
            // 缓冲试图
            ybDelegate?.dismisspWithPictureCell(self)
            return
        }
        // 圆点
        var top = (scrollView.bounds.height - pictureView.viewHeight) * 0.5
        var left = (scrollView.bounds.width - pictureView.viewWidth) * 0.5
        
        if top < 0 {top = 0}
        if left < 0 {left = 0}
        
        UIView.animateWithDuration(0.25) { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        }
    }
    
}
