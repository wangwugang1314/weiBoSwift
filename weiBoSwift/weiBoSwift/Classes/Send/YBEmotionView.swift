//
//  YBEmotionView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/12.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

/// 自动以代理
protocol YBEmotionViewDelegate: NSObjectProtocol {
    
    /// 选择某行调用
    func emotionView(emotionView: YBEmotionView, emotionModel: YBEmotionModel)
    /// 滑动调用
    func emotionView(emotionView: YBEmotionView, indexPath: NSIndexPath)
}

class YBEmotionView: UICollectionView {

    // MARK: - 属性
    /// 数据
    var dataArr: [YBEmotionGroupModel]? {
        didSet {
            reloadData()
        }
    }
    
    static var onceToken: Int = 0
    
    /// 上次的页数
    private var page = 1
    
    /// 布局
    private let layout = UICollectionViewFlowLayout()
    
    /// 代理
    weak var ybDelegate: YBEmotionViewDelegate?
    
    // MARK: - 构造函数
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        // 注册cell
        registerClass(YBEmotionCell.self, forCellWithReuseIdentifier: "YBEmotionCell")
        backgroundColor = UIColor.whiteColor()
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置布局
        let itemWith = UIScreen.width() / 7;
        layout.itemSize = CGSize(width: itemWith, height: itemWith)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 水平滚动
        layout.scrollDirection = .Horizontal
        // 设置collectionView
        delegate = self
        dataSource = self
        pagingEnabled = true
        bounces = false
    }
    // MARK: - 懒加载
}

extension YBEmotionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - 数据源方法
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?[section].emotions?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier("YBEmotionCell", forIndexPath: indexPath) as! YBEmotionCell
        cell.dataModel = dataArr?[indexPath.section].emotions?[indexPath.item] ?? nil
        
        // 讲试图移到最近
        dispatch_once(&YBEmotionView.onceToken) {[unowned self] () -> Void in
            self.contentOffset.x = UIScreen.width()
        };
        
        return cell
    }
    
    // MARK: - 代理
    /// 停止滚动调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取当前页数
        var page = Int(scrollView.contentOffset.x / scrollView.viewWidth)
        // 如果这次的页数等于上次直接返回
        if page == self.page {return}
        self.page = page
        var section = 0
        // 转化成indexPath
        for index in 0..<dataArr!.count {
            if page - dataArr![index].pageNum < 0 {
                section = index
                break
            }
            page -= dataArr![index].pageNum
        }
        // 代理
        ybDelegate?.emotionView(self, indexPath: NSIndexPath(forItem: page, inSection: section))
    }
    
    /// 选择调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 获取选定的模型
        let model = (collectionView.cellForItemAtIndexPath(indexPath) as! YBEmotionCell).dataModel
        ybDelegate?.emotionView(self, emotionModel: model!)
        // 如果是删除按钮直接返回
        if model?.deleteStr != nil {return}
        
        // 点击次数加1
        model?.selNum++
        
        // 取出最近组
        var latelyGroup = dataArr![0].emotions!
        
        // 查看最近中是否有
        let isHave = latelyGroup.contains(model!)
        // 没有就添加
        if !isHave {
            latelyGroup.insert(model!, atIndex: 0)
            
        }
        
        // 排序
        latelyGroup = latelyGroup.sort({ (obj1, obj2) -> Bool in
            obj1.selNum > obj2.selNum
        })
        
        // 没有就删除
        if !isHave {
            // 删除删除前面的那个
            latelyGroup.removeAtIndex(19)
        }
        
        // 赋值回去
        dataArr![0].emotions = latelyGroup
        
        // 如果点击的时第一组不更新数据
        if indexPath.section != 0 {
            reloadData()
        }
    }
}














