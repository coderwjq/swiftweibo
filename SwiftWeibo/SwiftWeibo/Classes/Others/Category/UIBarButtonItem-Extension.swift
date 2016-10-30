//
//  UIBarButtonItem-Extension.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/30.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
//    convenience init(imageName: String) {
//        self.init()
//        
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), for: .normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        
//        self.customView = btn
//    }
    
    convenience init(imageName: String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
}
