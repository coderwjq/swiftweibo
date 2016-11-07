//
//  StatusViewModel.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/3.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    // MARK:- 定义属性
    var status: Status?
    var cellHight: CGFloat = 0
    
    // MARK:- 对数据处理的属性
    var sourceText: String?         // 处理微博来源
    var createdAtText: String?      // 处理发布时间
    var verifiedImage: UIImage?     // 处理用户认证图标
    var vipImage: UIImage?          // 处理会员等级图标
    var profileURL: URL?            // 处理用户头像的地址
    var picURLs: [URL] = [URL]()    // 处理微博配图的数据
    
    // MARK:- 自定义构造函数
    init(status: Status) {
        self.status = status
        
        // 处理微博来源
        // if语句的判断条件中,如果同时包含可选绑定和其他条件,使用","进行并列
        if let source = status.source , source != "" {
            // 获取起始位置和截取长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            // 截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        // 处理发布时间
        if let createAt = status.created_at {
            createdAtText = Date.createDateString(createAt)
        }
        
        // 处理认证图标
        let verifiedType = status.user?.verified_type ?? -1
        
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 处理用户头像
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
        
        // 处理配图数据
        let picURLDicts = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
}
