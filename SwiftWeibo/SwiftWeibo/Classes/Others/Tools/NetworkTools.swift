//
//  NetworkTools.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/1.
//  Copyright © 2016年 wjq. All rights reserved.
//

import AFNetworking

// 定义枚举类型的请求方法
enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    
    // swift中单例的设计方法,注意:let是线程安全的
    static let sharedInstance: NetworkTools = {
        let tools = NetworkTools()
        
        // 设置tools的属性
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
        
    }() // 最后加括号,代表着执行闭包

}

// MARK:- 封装请求方法
extension NetworkTools {
    func request(methodType: RequestType, URLString: String, parameters: [String : Any], finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        // 定义成功回调的闭包
        let successCallBack = { (task: URLSessionDataTask?, result: Any) -> Void in
            finished(result, nil)
        }
        
        // 定义失败回调的闭包
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) -> Void in
            finished(nil, error)
        }
        
        // 发送网络请求
        if methodType == .GET {
            get(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK:- 请求AccessToken
extension NetworkTools {
    func loadAccessToken(code: String, finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        // 获取请求的URLString
        let urlString = url_request_access_token
        
        // 获取请求的参数
        let parameters = ["client_id": app_key, "client_secret": app_secret, "grant_type": "authorization_code", "redirect_uri": redirect_uri, "code": code]
        
        // 发送网络请求
        request(methodType: .POST, URLString: urlString, parameters: parameters) { (result, error) in
            finished(result, error)
        }
    }
}

// MARK:- 请求用户的信息
extension NetworkTools {
    func loadUserInfo(accessToken: String, uid: String, finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        // 获取请求的URLString
        let urlString = url_request_user_info
        
        // 获取请求的参数
        let parameters = ["access_token": accessToken, "uid": uid]
        
        // 发送网络请求
        request(methodType: .GET, URLString: urlString, parameters: parameters) { (result, error) in
            finished(result, error)
        }
    }
}

// MARK:- 请求首页数据
extension NetworkTools {
    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        guard let accessToken = UserAccountViewModel.sharedInstance.account?.access_token else {
            return
        }
        
        // 获取请求参数
        let parameters = ["access_token": accessToken, "since_id": "\(since_id)", "max_id": "\(max_id)"]
        
        // 发送网络请求
        request(methodType: .POST, URLString: url_request_homepage, parameters: parameters) { (result, error) in
            // 获取字典中的数据
            guard let resultDict = result as? [String : AnyObject] else{
                finished(nil, error)
                return
            }
            
            // 将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}
