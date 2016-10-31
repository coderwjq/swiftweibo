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
    
    // 注意:在闭包中,如果使用当前对象的属性或者调用方法,也需要加上self
    // 两个地方需要使用self:
    // 1.如果在一个函数中出现歧义,需要加上self
    // 2.在闭包中使用当前对象的属性和方法,也需要加上self
    fileprivate lazy var popoverAnimator: WJQPopoverAnimator = WJQPopoverAnimator {[weak self] (isPresented) in
        self?.titleBtn.isSelected = isPresented
    }
    
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
        
        // 设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        let width: CGFloat = 180
        let height: CGFloat = 250
        let screenWidth = UIScreen.main.bounds.size.width
        let x: CGFloat = (screenWidth - width) * 0.5
        let y: CGFloat = 55
        popoverAnimator.presentedFrame = CGRect(x: x, y: y, width: width, height: height)
        
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}
