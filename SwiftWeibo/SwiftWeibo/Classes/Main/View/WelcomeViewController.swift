//
//  WelcomeViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/3.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK:- 拖线的属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconView.layer.cornerRadius = 45
        iconView.layer.masksToBounds = true

        // 设置头像
        let profileURLString = UserAccountViewModel.sharedInstance.account?.avatar_large
        
        // ??: 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        // 如果??前面的可选类型为nil,那么直接使用??后面的值
        let iconURL = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "avatar_default_big"))

        // 改变约束值
        iconViewBottomCons.constant = UIScreen.main.bounds.size.height * 0.7
        
        // 执行动画
        // usingSpringWithDamping: 阻力系数,阻力系数越大,弹动的效果越不明显,取值0到1
        // initialSpringVelocity: 初始化速度
        // 枚举参数,如果不写,可用[]代替
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: {
            self.iconView.layoutIfNeeded()
        }) { (_) in
            // 将控制器的根控制器改为从MainViewController加载
            UIApplication.shared.keyWindow?.rootViewController = MainViewController()
        }
    }

}
