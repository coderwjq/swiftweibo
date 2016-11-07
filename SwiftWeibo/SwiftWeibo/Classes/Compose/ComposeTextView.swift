//
//  ComposeTextView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/7.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    // MARK:- 懒加载属性
    fileprivate lazy var placeHolderLabel: UILabel = UILabel()
    
    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }

}

// MARK:- 设置UI界面
extension ComposeTextView {
    fileprivate func setupUI() {
        // 添加子控件
        addSubview(placeHolderLabel)
        
        // 设置frame
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        // 设置placeHolderLabel的属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        
        // 设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)
    }
}
