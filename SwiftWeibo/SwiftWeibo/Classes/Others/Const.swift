//
//  Const.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/1.
//  Copyright © 2016年 wjq. All rights reserved.
//

import Foundation

// MARK:- 新浪微博授权相关常量
let app_key = "3467343333"
let app_secret = "99cffaeff85c7e8e18a95913de1479d7"
let redirect_uri = "http://www.520it.com"

/// 新浪微博请求授权的页面
let url_oauth_page = "https://api.weibo.com/oauth2/authorize"

/// 新浪微博请求AccessToken的url
let url_request_access_token = "https://api.weibo.com/oauth2/access_token"

/// 新浪微博请求用户信息的url
let url_request_user_info = "https://api.weibo.com/2/users/show.json"
