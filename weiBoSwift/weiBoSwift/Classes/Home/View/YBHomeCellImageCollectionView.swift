//
//  YBHomeCellImageCollectionView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

/// 点击图片通知
let YBHomeCellImageClickNotification = "YBHomeCellImageClickNotification"

class YBHomeCellImageCollectionView: UICollectionView {
    
    // MARK: - 属性
    /// 布局方式
    private let layout = UICollectionViewFlowLayout()
    /// 数据
    var dataModel: YBWeiBoModel? {
        didSet {
            // 设置布局
            setLayout()
            reloadData()
        }
    }
    
    // MARK: -构造方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        self.delegate = self;
        self.dataSource = self;
        registerClass(YBHomeImageCell.self, forCellWithReuseIdentifier: "YBHomeImageCell")
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    /// 准备UI
    private func prepareUI(){
        // 设置间隔
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
    }
    
    /// 设置布局
    func setLayout() {
        // 设置间距
        let itemWid = (UIScreen.width() - 30) / 3
        if let count = dataModel?.imageURLs.count {
            if count == 1 {
                layout.itemSize = dataModel!.imageSize
            } else if count > 1 {
                layout.itemSize = CGSizeMake(itemWid, itemWid)
            }
        }
    }
    
    /// 计算collectionView大小
    func countCollectionSize() -> CGSize {
        let count = dataModel?.imageURLs.count ?? 0
        let itemWid = (UIScreen.width() - 30) / 3
        switch count {
        case 1: return dataModel!.imageSize
        case 2, 3: return CGSizeMake(CGFloat(count) * itemWid + (CGFloat(count) - 1) * 5, itemWid)
        case 4: return CGSizeMake(2 * itemWid + 5, 2 * itemWid + 5)
        case 5, 6: return CGSizeMake(3 * itemWid + 10, 2 * itemWid + 5)
        case 7, 8, 9: return CGSizeMake(3 * itemWid + 10, 3 * itemWid + 10)
        default : return CGSizeZero
        }
    }
    
    // MARK: - 懒加载
}

/// 代理、扩展
extension YBHomeCellImageCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel?.imageURLs.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier("YBHomeImageCell", forIndexPath: indexPath) as! YBHomeImageCell
        
        cell.dataUrl = dataModel?.imageURLs[indexPath.row];
        
        return cell
    }
    
    // MA
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dataModel!.index = indexPath.item
        /// 获取所有的frame
        var frames = [CGRect]()
        let count = dataModel!.imageURLs.count
        for i in 0..<count {
            
            let cell = cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))

            frames.append(cell!.superview!.convertRect((cell?.frame)!, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!))
        }
        
        dataModel?.imageViewFrames = frames
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(YBHomeCellImageClickNotification, object: nil, userInfo: ["dataModel" : dataModel!])
    }
}