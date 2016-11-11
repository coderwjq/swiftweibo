//
//  PhotoBrowserAnimator.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate: NSObjectProtocol {
    func startRect(indexPath: IndexPath) -> CGRect
    func endRect(indexPath: IndexPath) -> CGRect
    func imageView(indexPath: IndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    func indexPathForDismissView() -> IndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented: Bool = false
    
    var presentedDelegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    var indexPath: IndexPath?
}

// MARK:- 遵守转场代理
extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDimissView(transitionContext: transitionContext)
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // nil值校验
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        // 取出弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        
        // 获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        
        // 将imageView添加到转场上下文的containerView中
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        // 执行动画
        presentedView?.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
            }) { (_) in
                imageView.removeFromSuperview()
                presentedView?.alpha = 1.0
                transitionContext.containerView.backgroundColor = UIColor.clear
                transitionContext.completeTransition(true)
        }
    }
    
    func animationForDimissView(transitionContext: UIViewControllerContextTransitioning) {
        // nil值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        // 取出消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        dismissView?.removeFromSuperview()
        
        // 获取执行动画的ImageView
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
}
