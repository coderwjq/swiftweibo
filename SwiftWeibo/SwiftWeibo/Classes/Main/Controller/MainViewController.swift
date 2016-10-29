//
//  MainViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/28.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 从json中动态加载子控制器
        // 获取json文件的路径
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings", ofType: "json") else {
            print("没有获取到对应的文件路径")
            return
        }
        
        // 读取json文件中的内容(以Data的形式)
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            print("没有获取到json文件中的数据")
            return
        }
        
        // 将Data转成字典数组
        
        // 如果在调用某一系统方法时,该方法最后有一个throws,说明该方法会抛出异常.
        // 如果一个方法会抛出异常,那么需要对该异常进行处理.
        
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        
        guard let dictArray = anyObject as? [[String: Any]] else {
            return
        }
        
        // 遍历字典数组
        for dict in dictArray {
            // 获取控制器的对应字符串
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            
            // 获取控制器显示的title
            guard let title = dict["title"] as? String else {
                continue
            }
            
            // 获取控制器显示的图标名称
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            
            // 添加子控制器
            addChildViewController(vcName, title: title, imageName: imageName)
        }
    }

    // swift支持方法的重载:方法名称相同,参数不同.
    // 1.参数的类型不同 2.参数的个数不同
    // swift中修饰私有方法有两个关键字:
    // fileprivate:在当前文件中可以访问,但是其他文件不能访问
    // private:只能在当前类中访问,但是在其他类中不能访问,即使两个类在同一个文件
    private func addChildViewController(_ vcName: String, title: String, imageName: String) {
        // 从plist中获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取到命名空间")
            return
        }
        
        // 根据字符串获取对应的class,并将对应的anyObject转成控制器类型
        guard let childVcType = NSClassFromString(nameSpace + "." + vcName) as? UIViewController.Type else {
            print("没有获取到对应的控制器类型")
            return
        }

        // 创建控制器对象
        let childVc = childVcType.init()
        
        // 设置子控制器的属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        // 包装的导航控制器
        let childNav = UINavigationController(rootViewController: childVc)
        
        // 添加子控制器
        addChildViewController(childNav)
    }
}
