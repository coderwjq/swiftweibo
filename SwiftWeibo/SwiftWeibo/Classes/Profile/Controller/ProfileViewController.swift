//
//  ProfileViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/28.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }

}
