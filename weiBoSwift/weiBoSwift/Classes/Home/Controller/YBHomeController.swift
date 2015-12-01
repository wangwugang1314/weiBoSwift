//
//  YBHomeController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class YBHomeController: YBBaseTableViewController {
    
    // MARK: - 属性
    private var dataArr: [YBWeiBoModel]? {
        didSet{
            // 更新数据
            tableView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 如果是访客试图直接返回
        if view is YBVisitView {
            return
        }
        // 加载用户数据
        loadWeiBoData()
        // 注册cell
        tableView.registerClass(YBHomeTableViewCell.self, forCellReuseIdentifier: "YBHomeTableViewCell")
        // 准备UI
        prepareUI()
        // 通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "homePopDismissedControllerNotification", name: YBHomePopDismissedControllerNotification,
            object: nil)
    }
    
    // MARK: - 加载微薄数据
    private func loadWeiBoData() {
        YBWeiBoModel.loadWeiBoData { (dataArr, error) -> () in
            if error { // 数据加载出错
                SVProgressHUD.showErrorWithStatus("数据加载出错")
            }else{// 数据加载成功
                if dataArr != nil { // 有新数据
                    self.dataArr = dataArr
                }else{ // 没有新数据
                    
                }
                SVProgressHUD.showSuccessWithStatus("加载了\(dataArr!.count)条数据")
            }
        }
    }
    
    // MARK: - 通知
    @objc private func homePopDismissedControllerNotification(){
        titleViewClick(titleView)
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置导航栏
        setNavigationBar()
    }
    
    /// 设置导航栏
    private func setNavigationBar(){
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendsearch"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemClick")
        // 中间
        navigationItem.titleView = titleView
    }
    
    // MARK: - 按钮点击
    /// 导航栏左边按钮点击
    @objc private func leftBarButtonItemClick(){
        print("导航栏左边按钮点击\(self)")
    }
    
    /// 导航栏右边按钮点击
    @objc private func rightBarButtonItemClick(){
        presentViewController(YBNavScanCodeController(), animated: true, completion: nil)
    }
    
    /// 导航栏中间按钮点击
    @objc private func titleViewClick(but: UIButton){
        but.selected = !but.selected
        if !but.selected {
            let popVC = YBHomePopViewController()
            // 设置弹出样式（后面的控制器不会消失）
            popVC.modalPresentationStyle = .Custom
            // 设置代理
            popVC.transitioningDelegate = self
            presentViewController(popVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - 懒加载
    /// 导航栏中间按钮
    private lazy var titleView: YBHomeNavTitleView = {
        let titleView = YBHomeNavTitleView()
        // 添加点击事件
        titleView.addTarget(self, action: "titleViewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return titleView
    }()
}

/// 扩展、代理
extension YBHomeController: UIViewControllerTransitioningDelegate {
    
    // MARK: - tableView数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YBHomeTableViewCell") as! YBHomeTableViewCell
        // 设置数据
        cell.data = dataArr![indexPath.row]
        return cell
    }
    
    // MARK: - 专场动画代理
    /// 展现代理(实现这个方法控制器试图需要自己手动添加)
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YBHomePopPresentedController()
    }

    /// 消失代理
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YBHomePopDismissedController()
    }
    
    /// 专场动画代理
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return YBHomePresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

/// 展现代理
class YBHomePopPresentedController: NSObject, UIViewControllerAnimatedTransitioning {
    /// 动画持续时间
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    /// 动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let view = transitionContext.viewForKey(UITransitionContextToViewKey)
        // 手动添加控制器试图
        transitionContext.containerView()?.addSubview(view!)
        // view动画
        view?.transform = CGAffineTransformMakeScale(0.01, 0.01)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            view?.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                // 专场动画完一定告诉系统动画完成
                transitionContext.completeTransition(true)
        })
    }
}

/// pop控制器消失通知
let YBHomePopDismissedControllerNotification = "YBHomePopDismissedControllerNotification"

/// 消失代理
class YBHomePopDismissedController: NSObject, UIViewControllerAnimatedTransitioning {
    /// 动画持续时间
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    /// 动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 旋转按钮（通知）
        NSNotificationCenter.defaultCenter().postNotificationName(YBHomePopDismissedControllerNotification, object: nil)
        // view动画
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            transitionContext.viewForKey(UITransitionContextFromViewKey)?.transform = CGAffineTransformMakeScale(0.001, 0.001)
            transitionContext.containerView()?.alpha = 0
            }, completion: { (_) -> Void in
                // 专场动画完一定告诉系统动画完成
                transitionContext.completeTransition(true)
        })
    }
}



























