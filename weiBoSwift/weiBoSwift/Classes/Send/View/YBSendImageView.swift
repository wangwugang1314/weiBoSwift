//
//  YBSendImageView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class YBSendImageView: UICollectionView {

    // MARK: - 属性
    private let layout = UICollectionViewFlowLayout()
    
    /// 数据数组（保存图片）
    var dataArr = [UIImage(named: "compose_pic_add_highlighted")!]
    
    // MARK: - 构造函数
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        // 不允许滚动
        scrollEnabled = false
        // 隐藏
        hidden = true
        // 注册Cell
        registerClass(YBSendImageViewCell.self, forCellWithReuseIdentifier: "YBSendImageViewCell")
        // 背景颜色
        backgroundColor = UIColor.clearColor()
        // 准备UI
        prepareUI()
        
        // 通知
        notificatioon()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 通知
    private func notificatioon(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendToolBarImageClickNotification", name: "YBSendToolBarImageClickNotification", object: nil)
        // 获取到图片通知
        NSNotificationCenter.defaultCenter().addObserverForName("UIImagePickerControllerGetImageNotification", object: nil, queue: nil) {[unowned self] (notification) -> Void in
            // 获取索引
            let index = notification.userInfo!["index"] as! Int
            // 如果是100 （表示添加到后面）
            if index == 100 {
                self.dataArr.insert(notification.userInfo!["image"] as! UIImage, atIndex: self.dataArr.count - 1)
            }else{
                // 替换指定数据
                self.dataArr[index] = notification.userInfo!["image"] as! UIImage
            }
            // 如果大于1 显示
            if self.dataArr.count > 1 {
                self.hidden = false
            }
            // 刷新数据
            self.reloadData()
        }
    }
    
    @objc private func sendToolBarImageClickNotification(){
        // 查看图片个数
        if dataArr.count <= 6 {
            // 发通知弹出图片
            NSNotificationCenter.defaultCenter().postNotificationName("YBSendImageViewPresentNotification", object: nil)
        }else{
            SVProgressHUD.showErrorWithStatus("图片个数超出范围")
        }
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置代理
        delegate = self
        dataSource = self
        // 设置layout
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let itemWith = (UIScreen.width() - 40) / 3
        layout.itemSize = CGSize(width: itemWith, height: itemWith)
    }
    
    // MARK: - 懒加载
    
    // MARK: - 对象销毁
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

/// 代理
extension YBSendImageView: UICollectionViewDataSource, UICollectionViewDelegate, YBSendImageViewCellDelegate{

    // MARK: - 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier("YBSendImageViewCell", forIndexPath: indexPath) as! YBSendImageViewCell
        // 设置代理
        cell.ybDelegate = self
        // 设置数据
        cell.image = dataArr[indexPath.item]
        // 是否隐藏删除按钮
        cell.isHiddenDelBut = (indexPath.item == dataArr.count - 1) ? true : false
        return cell
    }
    
    // MARK: - collection代理
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 判断是否是最后一个点击
        if indexPath.item == dataArr.count - 1 {
            NSNotificationCenter.defaultCenter().postNotificationName("YBSendImageViewPresentNotification", object: nil)
        }else{
            // 发通知弹出图片
            NSNotificationCenter.defaultCenter().postNotificationName("YBSendImageViewPresentNotification", object: nil, userInfo: ["index" : indexPath.item])
        }
    }
    
    // MARK: - 自定义dialing
    /// 删除按钮点击代理
    func clickDelButWithSendImageViewCell(cell: YBSendImageViewCell) {
        // 根据cell获取indexPath
        let index = indexPathForCell(cell)!.item
        // 删除数据
        dataArr.removeAtIndex(index)
        // 更新数据
        reloadData()
        // 如果只剩下一个就隐藏
        if dataArr.count == 1 {
            hidden = true
        }
    }
}
