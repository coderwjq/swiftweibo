//
//  UITextView-Extension.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

extension UITextView {
    /// 获取TextView属性字符串对应的表情字符串
    func getEmoticonString() -> String {
        // 获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        // 返回字符串
        return attrMStr.string
    }
    
    /// 给TextView插入表情
    func insertEmoticon(emoticon: Emoticon) {
        // 空白表情不插入
        if emoticon.isEmpty {
            return
        }
        
        // 删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        // emoji表情
        if emoticon.emojiCode != nil {
            // 获取光标所在的位置
            let textRange = selectedTextRange!
            
            // 替换emoji表情
            replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        // 普通表情(需要使用图文混排)
        // 根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        // 保存文字大小
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        // 创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 将图片属性字符串替换到可变属性字符串的某一个位置
        // 获取光标所在的位置
        let range = selectedRange
        
        // 替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        // 显示属性字符串
        attributedText = attrMStr
        
        // 重置文字大小
        self.font = font
        
        // 将光标设置回原来位置加1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
