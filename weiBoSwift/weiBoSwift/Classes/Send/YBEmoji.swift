//
//  YBEmoji.swift
//  weiBoOC
//
//  Created by MAC on 15/12/11.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit

class YBEmoji: NSObject {
    
    class func emoji(code: String?) -> String {
        let scanner = NSScanner(string: code!)
        var result: UInt32 = 0
        scanner.scanHexInt(&result)
        return "\(Character(UnicodeScalar(result)))"
    }
    
}
