//
//  YBNewFeatureViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBNewFeatureViewController: UICollectionViewController {

    // MARK: - 属性
    /// 布局方式
    private let layout = UICollectionViewFlowLayout()
    /// item个数
    private let itemCount = 4;
    
    // MARK: - 构造方法
    init(){
        super.init(collectionViewLayout: layout)
        // 注册item
        collectionView?.registerClass(YBNewFeatuireCell.self, forCellWithReuseIdentifier: "YBNewFeatuireCell")
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置布局
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.size()
        layout.scrollDirection = .Horizontal;
        // 设置collectionView
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
    
    // MARK: - 数据源代理
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YBNewFeatuireCell", forIndexPath: indexPath) as! YBNewFeatuireCell
        
        cell.index = indexPath.item
        cell.isShowBut = false
        
        return cell
    }
    
    // MARK: - 代理
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == CGFloat(itemCount - 1) * UIScreen.width() {
            // 显示按钮
            let cell = collectionView?.visibleCells().last as! YBNewFeatuireCell
            cell.isShowBut = true
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidEndDecelerating(collectionView!)
    }
    
    // MARK: - 懒加载
    
    // 对象销毁
    deinit{
        print("\(self) - 销毁")
    }
}










