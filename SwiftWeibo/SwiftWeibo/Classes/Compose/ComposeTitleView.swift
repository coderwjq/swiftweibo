//
//  ComposeTitleView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/7.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleLabel: UILabel = UILabel()
    fileprivate lazy var screenNameLabel: UILabel = UILabel()
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI界面
extension ComposeTitleView {
    fileprivate func setupUI() {
        // 将子控件添加到view中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        // 设置frame
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        // 设置控件的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        // 设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.sharedInstance.account?.screen_name ?? "木喳喳de夏天"
    }
}
