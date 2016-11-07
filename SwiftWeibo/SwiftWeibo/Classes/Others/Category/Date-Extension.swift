//
//  Date-Extension.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/3.
//  Copyright © 2016年 wjq. All rights reserved.
//

import Foundation

extension Date {
    // 类方法,根据具体时间,返回对应的字符串
    static func createDateString(_ createAtStr: String) -> String {
        // 创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        // 将字符串时间转换成NSDate类型
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        
        // 创建当前时间
        let nowDate = Date()
        
        //计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 对时间间隔处理
        // 显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        
        // 显示多少分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 显示多少小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 创建日历对象
        let calendar = Calendar.current
        
        // 处理昨天数据
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 处理一年之内
        let cmps = (calendar as NSCalendar).components(.year, from: createDate, to: nowDate, options: [])
        
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 超过一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
