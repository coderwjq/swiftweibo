//
//  FindEmoticon.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    // MARK:- 设计单例对象
    static let sharedInstance: FindEmoticon = FindEmoticon()
    
    // MARK:- 懒加载属性
    fileprivate lazy var manager: EmoticonManager = EmoticonManager()
    
    // 查找属性字符串的方法
    func findAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
        // 如果statusText没有值,则直接返回nil
        guard let statusText = statusText else {
            return nil
        }
        
        // 创建匹配表情的规则
        let pattern = "\\[.*?\\]"
        
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // 开始匹配
        // 注意:获取swift中String类型字符串长度的方式为statusText.characters.count
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        // 倒序遍历,从后向前进行替换
        for result in results.reversed() {
            // 获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            
            // 根据chs获取图片的路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            
            // 创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            // 将属性字符串替换到来源的文字位置
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        
        // 返回结果
        return attrMStr
    }
    
    fileprivate func findPngPath(chs: String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        
        // 如果没有找到就返回nil
        return nil
    }
}
