//
//  VisitorView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/30.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    // MARK:- 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    // 提供一个快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    // MARK:- 自定义函数
    func setupVisitorViewInfo(iconName: String, title: String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    // 添加转盘动画
    func addRotationAnimation() {
        // 创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = 2 * M_PI
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 10.0
        
        // 设置是否在动画完成时移除动画
        rotationAnim.isRemovedOnCompletion = false
        
        // 添加动画
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
