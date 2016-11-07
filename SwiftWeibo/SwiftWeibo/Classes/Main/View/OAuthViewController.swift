//
//  OAuthViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/1.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏的内容
        setupNavigationBar()
        
        // 开始加载页面
        loadPage()
    }
    
}

// MARK:- 设置UI界面相关
extension OAuthViewController {
    fileprivate func setupNavigationBar() {
        // 设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 设置右侧item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 设置标题
        navigationItem.title = "登录界面"
    }
    
    fileprivate func loadPage() {
        print("开始加载页面")
        // 获取登录页的URLString
        let urlString = "\(url_oauth_page)?client_id=\(app_key)&redirect_url=\(redirect_uri)"
        
        // 创建对应的URL
        guard let url = URL(string: urlString) else {
            print("创建URL失败")
            return
        }
        
        // 创建URLRequest对象
        let request = URLRequest(url: url)
        
        // 加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听函数
extension OAuthViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        // 书写js代码
        var jsCode = "document.getElementById('userId').value='上当了吧';"
        jsCode += "document.getElementById('passwd').value='受骗了吧';"
        
        // 执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK:- webView的代理方法
extension OAuthViewController: UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值:true,继续加载该页面;false,不加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 获取加载页面的URL
        guard let url = request.url else {
            return true
        }
        
        // 获取URL中的字符串
        let urlString = url.absoluteString
        
        // 判断该字符串是否包含"code="
        guard urlString.contains(urlString) else {
            return true
        }
        
        // 将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
        // 根据code请求accessToken
        loadAccessToken(code: code)
        
        // 不再加载剩余页面
        return true
    }
}

// MARK:- 请求数据
extension OAuthViewController {
    // 请求AccessToken
    fileprivate func loadAccessToken(code: String) {
        NetworkTools.sharedInstance.loadAccessToken(code: code) { (result, error) in
            // 错误校验
            guard error == nil else {
                print(error)
                return
            }
            
            // 获取结果
            guard let accountDict = result else {
                print("未获取到授权后的数据")
                return
            }
            
            // 将字典转成模型对象
            let account = UserAccount(dict: accountDict as! [String : Any])
            
            // 请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    // 请求用户信息
    fileprivate func loadUserInfo(account: UserAccount) {
        // 获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        
        // 获取uid
        guard let uid = account.uid else {
            return
        }
        
        // 发送网络请求
        NetworkTools.sharedInstance.loadUserInfo(accessToken: accessToken, uid: uid) { (result, error) in
            // 错误校验
            guard error == nil else {
                print(error)
                return
            }
            
            // 拿到用户信息的结果
            guard let resultDict = result else {
                return
            }
            
            // 将resultDict转换为userInfoDict
            let userInfoDict = resultDict as! [String : Any]
            
            // 从字典中取出昵称和用户头像
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            print(account)
        }
    }
}
