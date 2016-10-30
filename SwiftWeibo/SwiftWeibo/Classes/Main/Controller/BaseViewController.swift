//
//  BaseViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/30.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // MARK:- 懒加载属性
    lazy var visitorView: VisitorView = VisitorView.visitorView()
    
    // MARK:- 定义变量
    var isLogin: Bool = false
    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }

}

// MARK:- 设置UI界面
extension BaseViewController {
    // 设置访客视图
    fileprivate func setupVisitorView() {
        view = visitorView
        
        // 监听访客视图中的注册和登录按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
    
    // 设置导航栏左右的item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}

// MARK:- 按钮的点击事件
extension BaseViewController {
    @objc fileprivate func registerBtnClick() {
        print("registerBtnClick")
    }
    
    @objc fileprivate func loginBtnClick() {
        print("loginBtnClick")
    }
}
