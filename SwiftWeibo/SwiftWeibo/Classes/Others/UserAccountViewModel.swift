//
//  UserAccountViewModel.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/3.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    // MARK:- 将类设置成单例
    static let sharedInstance: UserAccountViewModel = UserAccountViewModel()
    
    // MARK:- 定义属性
    var account: UserAccount?
    
    // MARK:- 计算属性
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin: Bool {
        if account == nil {
            return false
        }
        
        // 判断AccessToken是否过期
        guard let expiresDate = account?.expires_date else {
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedAscending
    }
    
    // MARK:- 重写init()函数
    init() {
        // 解档:从沙盒中读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
