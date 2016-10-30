//
//  HomeViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/28.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var titleBtn: TitleButton = TitleButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 没有登录时设置的内容
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
        // 设置导航栏的内容
        setupNavigationBar()
    }

}

// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        // 设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发微博", style: .plain, target: self, action: #selector(HomeViewController.publishStatus))
        
        // 设置titleView
        titleBtn.setTitle("coderwjq", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func publishStatus() {
        print("发布微博")
    }
    
    @objc fileprivate func titleBtnClick(titleBtn: TitleButton) {
        // 改变按钮的状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        // 创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}
