//
//  WJQPopoverAnimator.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/31.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class WJQPopoverAnimator: NSObject {
    
    // MARK:- 对外提供的属性
    var isPresented: Bool = false
    var presentedFrame: CGRect = CGRect.zero
    
    var callBack: ((_ isPresented: Bool) -> ())?
    
    // MARK:- 自定义构造函数
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数的init()方法进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack: @escaping (_ isPresented: Bool) -> ()) {
        self.callBack = callBack
    }

}

// MARK:- 自定义转场代理的方法
extension WJQPopoverAnimator: UIViewControllerTransitioningDelegate {
    // 目的:改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = WJQPresentationController(presentedViewController: presented, presenting: presented)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    // 目的:自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack!(isPresented)
        
        return self
    }
    
    // 目的:自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        callBack!(isPresented)
        
        return self
    }
}

// MARK:- 弹出和消失动画代理的方法
extension WJQPopoverAnimator:UIViewControllerAnimatedTransitioning {
    // 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    // 获取转场的上下文:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextViewKey.from : 获取消失的View
    // UITransitionContextViewKey.to : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissedView(using: transitionContext)
    }
    
    // 自定义弹出动画
    fileprivate func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的View
        let presentedView = transitionContext.view(forKey: .to)!
        
        // 将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            presentedView.transform = CGAffineTransform.identity
            }) { (_) in
                // 告诉转场上下文,已经完成了动画
                transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    fileprivate func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的View
        let dismissedView = transitionContext.view(forKey: .from)
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
            }) { (_) in
                // 移除完成动画的View
                dismissedView?.removeFromSuperview()
                
                // 告诉转场上下文,已经完成了动画
                transitionContext.completeTransition(true)
        }
    }
}
