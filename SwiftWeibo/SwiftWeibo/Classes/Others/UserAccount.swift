//
//  UserAccount.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/1.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class UserAccount: NSObject {

    // MARK:- 属性
    /// 授权AccessToken
    var access_token: String?
    
    /// 过期时间(单位:秒)
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 用户ID
    var uid: String?
    
    /// 过期日期
    var expires_date: Date?
    
    /// 昵称
    var screen_name: String?
    
    /// 用户头像地址
    var avatar_large: String?
    
    // MARK:- 自定义构造函数
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    // MARK:- 在swift中,重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
}
