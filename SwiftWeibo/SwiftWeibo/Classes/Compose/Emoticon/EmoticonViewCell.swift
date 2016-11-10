//
//  EmoticonViewCell.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    // MARK:- 懒加载属性
    fileprivate lazy var emoticonBtn: UIButton = UIButton()
    
    // MARK:- 定义的属性
    var emoticon: Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            
            // 设置emoticonBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: UIControlState())
            emoticonBtn.setTitle(emoticon.emojiCode, for: UIControlState())
            
            // 设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState())
            }
        }
    }
    
    // MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 设置UI界面内容
extension EmoticonViewCell {
    fileprivate func setupUI() {
        // 添加子控件
        contentView.addSubview(emoticonBtn)
        
        // 设置btn的frame
        emoticonBtn.frame = contentView.bounds
        
        // 设置btn的属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
