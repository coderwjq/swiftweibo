//
//  User.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/3.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class User: NSObject {

    // MARK:- 属性
    var profile_image_url: String?  // 用户的头像
    var screen_name: String?        // 用户的昵称
    var verified_type: Int = -1     // 用户的认证类型
    var mbrank: Int = 0             // 用户的会员等级
    
    // MARK:- 自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // 设置字典中没有定义的属性
    }
}
