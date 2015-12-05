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

// 最小缩放比例
let YBHomeImageScrollViewMinScale: CGFloat = 0.4

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
            SDWebImageManager.sharedManager().downloadImageWithURL(imageUrl, options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize) -> Void in
                }) { [unowned self] (image, error, _, _, _) -> Void in
                    self.pictureView.image = image
                    SVProgressHUD.dismiss()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.pictureView.frame = CGRectMake(0, 0, UIScreen.width(), image.size.height * (UIScreen.width() / image.size.width))
                        self.scrollView.contentInset = UIEdgeInsets(top: (self.scrollView.viewHeight - self.pictureView.viewHeight) * 0.5, left: 0, bottom: 0, right: 0)
                        self.pictureView.hidden = false
                    })
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
        view.backgroundColor = UIColor.orangeColor()
        view.minimumZoomScale = YBHomeImageScrollViewMinScale
        view.maximumZoomScale = 2
        view.delegate = self;
        return view
    }()
    
    /// imageView
    lazy var pictureView: YBHomeImageView = {
        let view = YBHomeImageView()
        return view
    }()
    
    
}

extension YBHomePictureCell: UIScrollViewDelegate {
    
    /// 设置要缩放的试图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pictureView;
    }
    
    /// 缩放完成调用
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        // 圆点
        var top = (scrollView.bounds.height - pictureView.viewHeight) * 0.5
        var left = (scrollView.bounds.width - pictureView.viewWidth) * 0.5
        
        if top < 0 {top = 0}
        if left < 0 {left = 0}
        
        UIView.animateWithDuration(0.25) { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: 0, right: 0)
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
    }
}
