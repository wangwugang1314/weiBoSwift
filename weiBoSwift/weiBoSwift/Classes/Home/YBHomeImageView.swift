//
//  YBHomeImageView.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBHomeImageView: UIImageView {

    override var transform: CGAffineTransform {
        didSet {
            if transform.a < YBHomeImageScrollViewMinScale {
                transform = CGAffineTransformMakeScale(YBHomeImageScrollViewMinScale, YBHomeImageScrollViewMinScale)
            }
        }
    }
}
