//
//  AppDelegate.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/28.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置全局UITabBar的样式
        UITabBar.appearance().tintColor = UIColor.orange
        
        // 设置window的大小为屏幕大小
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 设置window的根控制器
        window?.rootViewController = MainViewController()
        
        // 设置window为可见
        window?.makeKeyAndVisible()
        
        return true
    }

}

