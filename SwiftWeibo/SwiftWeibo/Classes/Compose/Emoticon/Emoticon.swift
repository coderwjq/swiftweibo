//
//  Emoticon.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    // MARK:- 定义属性
    /// emoji的code
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            
            /* 将emoji对应的代码转为字符串显示 */
            // 1.创建扫描器
            let scanner = Scanner(string: code)
            
            // 2.调用方法,扫描出code中的值
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value)!)
            
            // 4.将字符转成字符串
            emojiCode = String(c)
        }
    }
    
    /// 普通表情对应的图片名称
    var png: String? {
        didSet {
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    
    /// 普通表情对应的文字
    var chs: String?
    
    // MARK:- 数据处理
    var pngPath: String?
    var emojiCode: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    // MARK:- 自定义构造函数
    init(dict: [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = true
    }
    
    init(isRemove: Bool) {
        self.isRemove = true
    }
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).description
    }
}
