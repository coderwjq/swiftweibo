//
//  UIButton-Extension.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

extension UIButton {
    // 便利构造函数
    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
    }
}
