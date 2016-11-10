//
//  EmoticonPackage.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    
    // MARK:- 定义属性
    var emoticons: [Emoticon] = [Emoticon]()
    
    // MARK:- 系统回调函数
    init(id: String) {
        super.init()
        
        // 判断是否是最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        // 根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        // 根据plist文件的路径读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        
        // 遍历数组
        var index = 0
        
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emoticons.append(Emoticon(dict: dict))
            index += 1
            
            if index == 20 {
                // 添加删除表情
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        
        // 添加空白表情
        addEmptyEmoticon(isRecently: false)
    }

    // MARK:- 自定义函数
    fileprivate func addEmptyEmoticon(isRecently: Bool) {
        let count = emoticons.count % 21
        
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
    }
}
