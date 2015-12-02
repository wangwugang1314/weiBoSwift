//
//  YBHomeCellTopView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeCellTopView: UIView {

    // MARK: - 属性
    var data: YBWeiBoModel? {
        didSet{
            let userModel = data?.user as! YBWeIBoUserModel
            // 头像
            iconView.sd_setImageWithURL(NSURL(string: userModel.profile_image_url!), placeholderImage: UIImage(named: "sec_session_recent_icon"))
            // 名称
            nameView.text = userModel.name
            nameView.textColor = userModel.mbrank == 0 ? UIColor.blackColor() : UIColor.magentaColor()
            // 认证
            verifiedView.image = userModel.verifiedImage
            // VIP
            vipView.image = userModel.vipImage
            // 创建时间
            createTimeView.text = data?.created_at
            // 来源
            sourceView.text = data?.source
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.purpleColor()
        
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 头像
        addSubview(iconView)
        iconView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 5, y: 5))
        // 名称
        addSubview(nameView)
        nameView.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 3))
        // 认证
        addSubview(verifiedView)
        verifiedView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14))
        // VIP
        addSubview(vipView)
        vipView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 8, y: -1))
        // 创建时间
        addSubview(createTimeView)
        createTimeView.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: -4))
        // 微薄来源
        addSubview(sourceView)
        sourceView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: createTimeView, size: nil, offset: CGPoint(x: 8, y: 0))
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 25
        return view
    }()
    
    /// 名称
    private lazy var nameView: UILabel = {
        let view = UILabel()
        return view
    }()
    
    /// 认证
    private lazy var verifiedView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    /// VIP
    private lazy var vipView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    /// 创建时间
    private lazy var createTimeView: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFontOfSize(12)
        return view
    }()
    
    /// 微薄来源
    private lazy var sourceView: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFontOfSize(12)
        return view
    }()
}
