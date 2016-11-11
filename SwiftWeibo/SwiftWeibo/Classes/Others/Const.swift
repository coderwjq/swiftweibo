//
//  Const.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/1.
//  Copyright © 2016年 wjq. All rights reserved.
//

import Foundation

// MARK:- 新浪微博授权相关常量
let app_key = "2501674134"
let app_secret = "46e7fcb01fcd8f488e7b72a86222cc5d"
let redirect_uri = "http://www.baidu.com"

/// 新浪微博请求授权的页面
let url_oauth_page = "https://api.weibo.com/oauth2/authorize"

/// 新浪微博请求AccessToken的url
let url_request_access_token = "https://api.weibo.com/oauth2/access_token"

/// 新浪微博请求用户信息的url
let url_request_user_info = "https://api.weibo.com/2/users/show.json"

/// 新浪微博请求首页数据的url
let url_request_homepage = "https://api.weibo.com/2/statuses/home_timeline.json"

// MARK:- 选择照片的通知常量
let PicPickerAddPhotoNote = "PicPickerAddPhotoNote"
let PicPickerRemovePhotoNote = "PicPickerRemovePhotoNote"

// MARK:- 照片浏览器的通知常量
let ShowPhotoBrowserNote = "ShowPhotoBrowserNote"
let ShowPhotoBrowserIndexKey = "ShowPhotoBrowserIndexKey"
let ShowPhotoBrowserUrlsKey = "ShowPhotoBrowserIndexKey"
