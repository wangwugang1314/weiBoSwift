//
//  YBHomeController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

/// 数据加载类型
private enum YBHomeLoadDataStyle : Int {

    case new
    case old
}

class YBHomeController: YBBaseTableViewController {
    
    // MARK: - 属性
    private var dataArr: [YBWeiBoModel]? {
        didSet{
            // 更新数据
            tableView.reloadData()
        }
    }
    
    /// 记录动画是否完成(标记多少个更新数据)
    private var isAnimationFinish = true
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果是访客试图直接返回
        if view is YBVisitView {
            return
        }
        // 注册cell
        tableView.registerClass(YBHomeTableViewCell.self, forCellReuseIdentifier: "YBHomeTableViewCell")
        // 准备UI
        prepareUI()
        // 通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YBHomeController.homePopDismissedControllerNotification), name: YBHomePopDismissedControllerNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YBHomeController.homeCellImageClickNotification(_:)), name: YBHomeCellImageClickNotification, object: nil)
        tableView.estimatedRowHeight = 400
        // 加载用户数据
        loadWeiBoData(YBHomeLoadDataStyle.new)
        // 设置刷新控件
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] () -> Void in
            self.loadWeiBoData(YBHomeLoadDataStyle.new)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self] () -> Void in
            self.loadWeiBoData(YBHomeLoadDataStyle.old)
        })
        tableView.mj_header.beginRefreshing()
        // 取消每行之间的分割线
        tableView.separatorStyle = .None;
    }
    
    // MARK: - 加载微薄数据
    private func loadWeiBoData(type: YBHomeLoadDataStyle) {

        // 下拉加载新数据
        var newId = 0
        var oldId = 0
        if type == .new && dataArr != nil{ // 上啦加载最新数据
            newId = dataArr![0].Id
        } else if type == .old {
            oldId = dataArr!.last!.Id
        }
        
        YBWeiBoModel.loadWeiBoData(newId, max_id: oldId) {[unowned self] (dataArr, isError) -> () in
            // 结束刷新控件
            if type == .new{ // 上啦加载最新数据
                self.tableView.mj_header.endRefreshing()
            } else if type == .old {
                self.tableView.mj_footer.endRefreshing()
            }
            
            if isError { // 数据加载出错
                SVProgressHUD.showErrorWithStatus("数据加载出错")
            }else{// 数据加载成功
                if dataArr?.count != 0 { // 有新数据
                    // 判断记载数据的类型
                    switch type {
                    case .new:
                        if self.dataArr != nil {
                            self.dataArr?.insertContentsOf(dataArr!, at: 0)
                        }else{
                            self.dataArr = dataArr
                        }
                    case .old:
                        self.dataArr?.removeLast()
                        self.dataArr! += dataArr!;
                    }
                    self.showWeiBoNum.text = "加载了\(dataArr!.count)条微薄"
                }else{ // 没有新数据
                    self.showWeiBoNum.text = "没有新微薄"
                }
                if type == .new {
                    // 如果正在动画就返回
                    self.showWeiBoNum.alpha = 0.8
                    if self.isAnimationFinish {
                        // 标记动画开始
                        self.isAnimationFinish = false
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.showWeiBoNum.frame = CGRect(x: 0, y: 44, width: UIScreen.width(), height: 40)
                            }, completion: { (_) -> Void in
                                UIView.animateWithDuration(0.5, delay: 1.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                                    self.showWeiBoNum.frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: 40)
                                    }, completion: { (_) -> Void in
                                        self.showWeiBoNum.alpha = 0
                                        // 标记动画完成
                                        self.isAnimationFinish = true
                                })
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - 通知
    @objc private func homePopDismissedControllerNotification(){
        titleViewClick(titleView)
    }
    
    @objc private func homeCellImageClickNotification(notification: NSNotification){
        // 图片轮播器控制器
        let vc = YBHomePictureShowController(model: notification.userInfo!["dataModel"] as! YBWeiBoModel)
        // 设置弹出样式（后面的控制器不会消失）
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置导航栏
        setNavigationBar()
        // 显示微薄条数
        navigationController?.navigationBar.addSubview(showWeiBoNum)
        navigationController?.navigationBar.sendSubviewToBack(showWeiBoNum)
        showWeiBoNum.frame = CGRect(x: 0, y: -20, width: UIScreen.width(), height: 40)
    }
    
    /// 设置导航栏
    private func setNavigationBar(){
        // 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendsearch"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(YBHomeController.leftBarButtonItemClick))
        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(YBHomeController.rightBarButtonItemClick))
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
    
    // MARK: - 行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = dataArr![indexPath.row]
        return model.rowHeight ?? 700
    }
    
    /// 点击行不显示高亮
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - 懒加载
    /// 导航栏中间按钮
    private lazy var titleView: YBHomeNavTitleView = {
        let titleView = YBHomeNavTitleView()
        // 添加点击事件
        titleView.addTarget(self, action: #selector(YBHomeController.titleViewClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return titleView
    }()
    
    /// 显示加载微薄条数
    private lazy var showWeiBoNum: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.orangeColor()
        view.textAlignment = NSTextAlignment.Center
        view.alpha = 0
        return view
    }()
}

/// 扩展、代理
extension YBHomeController: UIViewControllerTransitioningDelegate, YBHomeTableViewCellDelegate {
    
    // MARK: - tableView数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YBHomeTableViewCell") as! YBHomeTableViewCell
        // 如果是最后一行就加载
        if indexPath.row == dataArr!.count - 1 {
            loadWeiBoData(YBHomeLoadDataStyle.old)
        }
        cell.ybDelegate = self
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
    
    /// 点击网址调用
    func homeTableViewCell(cell: YBHomeTableViewCell, pathStr: String) {
        let vc = UINavigationController(rootViewController: YBHomeWebViewController(pathStr: pathStr))
        presentViewController(vc, animated: true, completion: nil)
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



























