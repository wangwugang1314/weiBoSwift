//
//  YBHomePopTableView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomePopTableView: UITableViewController {

    // MARK: - 构造方法
    init(){
        super.init(style: .Plain)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "YBHomePopTableViewCell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 数据数组
    private lazy var dataArr: [String] = ["000","111","222","333","444","555","666","777","888","999"]
}

/// 扩展、代理
extension YBHomePopTableView {
    // MARK: - 数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YBHomePopTableViewCell")
        cell?.textLabel?.text = dataArr[indexPath.row]
        return cell!
    }
}