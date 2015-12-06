//
//  YBHomePictureShowController.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD


class YBHomePictureShowController: UICollectionViewController {

    // MARK: - 属性
    private let layout = UICollectionViewFlowLayout()
    /// 数据
    private let dateModel: YBWeiBoModel
    
    // MARK: - 构造函数
    init(model: YBWeiBoModel) {
        dateModel = model
        super.init(collectionViewLayout: layout)
        // 设置collectiovView
        collectionView?.frame = CGRectMake(0, 0, UIScreen.width() + 10, UIScreen.height())
        collectionView?.contentSize = CGSizeMake(UIScreen.width() + 10, UIScreen.height())
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        // 图片索引
        pageView.text = "\(dateModel.index + 1)/\(dateModel.imageURLs.count)"
        // 设置专场动画代理
        transitioningDelegate = self
        // 注册
        collectionView?.registerClass(YBHomePictureCell.self, forCellWithReuseIdentifier: "YBHomePictureCell")
        // 设置布局方式
        setLayout()
        // 准备UI
        prepareUI()
    }
    
    /// 滚动
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 滚动到指定位置
        collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: dateModel.index, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
        print(collectionView?.visibleCells().last)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 标题
        view.addSubview(pageView)
        pageView.ff_AlignInner(type: ff_AlignType.TopCenter, referView: view, size: CGSize(width: 100, height: 40), offset: CGPoint(x: 0, y: 80))
        // 返回按钮
        view.addSubview(breakView)
        breakView.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: 80, height: 40), offset: CGPoint(x: 40, y: -40))
        // 保存按钮
        view.addSubview(saveImageView)
        saveImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: view, size: CGSize(width: 80, height: 40), offset: CGPoint(x: -40, y: -40))
    }
    
    /// 设置布局方式
    private func setLayout() {
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.width() + 10, height: UIScreen.height())
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    // MARK: - 按钮点击
    @objc private func breakViewClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 保存图片
    @objc private func saveImageViewClick(){
        let cell = collectionView?.visibleCells().last as! YBHomePictureCell
        if cell.pictureView.image == nil {
            SVProgressHUD.showErrorWithStatus("当前图片不可以保存")
            return
        }
        UIImageWriteToSavedPhotosAlbum(cell.pictureView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    /// 保存图片回调
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo: AnyObject) {
        SVProgressHUD.showSuccessWithStatus("图片保存成功")
    }
    
    // MARK: - 懒加载
    /// 页码
    private lazy var pageView: UILabel = {
        let view = UILabel()
        view.textAlignment = NSTextAlignment.Center
        return view
    }()
    
    /// 退出
    private lazy var breakView: UIButton = {
        let but = UIButton()
        but.setTitle("返回", forState: UIControlState.Normal)
        but.backgroundColor = UIColor(white: 0, alpha: 0.5)
        but.addTarget(self, action: "breakViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
    
    /// 保存图片
    private lazy var saveImageView: UIButton = {
        let but = UIButton()
        but.setTitle("保存", forState: UIControlState.Normal)
        but.backgroundColor = UIColor(white: 0, alpha: 0.5)
        but.addTarget(self, action: "saveImageViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return but
    }()
}

/// 扩展、代理
extension YBHomePictureShowController: UIViewControllerTransitioningDelegate, YBHomePictureCellDelegate {
    
    // MARK: - 数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateModel.imageURLs.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YBHomePictureCell", forIndexPath: indexPath) as! YBHomePictureCell
        cell.ybDelegate = self
        cell.imageUrl = dateModel.bigPictureUrls[indexPath.item]
        return cell
    }
    
    // MARK: - 代理方法
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageView.text = "\(Int(scrollView.contentOffset.x / scrollView.viewWidth) + 1)/\(dateModel.imageURLs.count)"
        dateModel.index = Int(scrollView.contentOffset.x / scrollView.viewWidth)
    }
    
    // MARK: - 转场动画代理
    /// 展现
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YBHomeImagePresentedAnimatedTransitioning()
    }
    
    /// 消失
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YBHomeImageDismissAnimatedTransitioning()
    }
    
    /// 转场动画
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return YBHomePicturePresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // MARK: - cell代理
    /// 控制器消失代理
    func dismisspWithPictureCell(cell: YBHomePictureCell) {
        breakViewClick()
    }
}

/// 展现
class YBHomeImagePresentedAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.25;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取展现后的view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        // 获取展现后的控制器
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! YBHomePictureShowController
        // 添加
        transitionContext.containerView()!.addSubview(toView!)
        // 隐藏view
        toView?.alpha = 0
        
        // 模型
        let dataModel = toVC.dateModel
        // 设置 imageView
        imageView.sd_setImageWithURL(dataModel.imageURLs[dataModel.index], placeholderImage: UIImage(named: "sys_qq_1"))
        imageView.frame = dataModel.imageViewFrames![dataModel.index]
        
        transitionContext.containerView()?.addSubview(imageView)
        transitionContext.containerView()?.backgroundColor = UIColor(white: 0, alpha: 0.3)
        // 图片位置
        let imageWid = UIScreen.width()
        let imageHei = UIScreen.width() * (imageView.image!.size.height / imageView.image!.size.width)
        let imageY = (UIScreen.height() - imageHei) * 0.5
        // 动画
        UIView.animateWithDuration(0.5, animations: {[unowned self] () -> Void in
            self.imageView.frame = CGRect(x: 0, y: imageY, width: imageWid, height: imageHei)
            }) {[unowned self] (_) -> Void in
                toView?.alpha = 1
                self.imageView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    /// 懒加载
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.orangeColor()
        view.contentMode = UIViewContentMode.ScaleAspectFill
        view.clipsToBounds = true
        return view
    }()
}

/// 消失动画
class YBHomeImageDismissAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.4;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取展现后的view
        let formView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        // 获取展现后的控制器
        let formVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! YBHomePictureShowController
        let cell = formVC.collectionView?.visibleCells().last as! YBHomePictureCell
        cell.pictureView.hidden = true
        // 获取图片的frame
        let imageFrame = cell.pictureView.convertRect(cell.pictureView.frame, toView: UIApplication.sharedApplication().keyWindow)
        
        // 模型
        let dataModel = formVC.dateModel
        // 设置 imageView
        imageView.sd_setImageWithURL(dataModel.bigPictureUrls[dataModel.index], placeholderImage: UIImage(named: "sys_qq_1"))
        // 设置frame
        
        imageView.frame = CGRect(x: imageFrame.origin.x, y: imageFrame.origin.y, width: cell.pictureView.frame.size.width, height: cell.pictureView.frame.size.height)
        
        transitionContext.containerView()?.addSubview(imageView)
        transitionContext.containerView()?.layoutIfNeeded()
        // 动画
        UIView.animateWithDuration(0.5, animations: {[unowned self] () -> Void in
            // 隐藏view
            formView?.alpha = 0
            self.imageView.frame = formVC.dateModel.imageViewFrames![dataModel.index]
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    /// 懒加载
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = UIViewContentMode.ScaleAspectFill
        view.backgroundColor = UIColor.orangeColor()
        view.clipsToBounds = true
        return view
    }()
}









