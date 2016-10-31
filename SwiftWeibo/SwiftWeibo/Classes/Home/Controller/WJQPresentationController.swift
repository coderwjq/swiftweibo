//
//  WJQPresentationController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/31.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class WJQPresentationController: UIPresentationController {

    // MARK:- 对外提供的属性
    var presentedFrame: CGRect = CGRect.zero
    
    // MARK:- 懒加载属性
    fileprivate lazy var coverView: UIView = UIView()
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // 设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        // 添加蒙版
        setupCoverView()
    }
    
}

// MARK:- 设置UI界面相关
extension WJQPresentationController {
    fileprivate func setupCoverView() {
        // 添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        // 设置蒙版属性
        coverView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        coverView.frame = containerView!.bounds
        
        // 添加Tap手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WJQPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGesture)
    }
}

// MARK:- 事件监听
extension WJQPresentationController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
        print("撤销蒙版")
    }
}
