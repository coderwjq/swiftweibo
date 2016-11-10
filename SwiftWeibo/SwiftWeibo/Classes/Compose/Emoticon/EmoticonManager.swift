//
//  EmoticonManager.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class EmoticonManager: NSObject {

    // MARK:- 定义属性
    var packages: [EmoticonPackage] = [EmoticonPackage]()
    
    // MARK:- 系统回调函数
    override init() {
        // 添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        
        // 添加默认表情的包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        // 添加emoji表情的包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        // 添加浪小花表情的包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
