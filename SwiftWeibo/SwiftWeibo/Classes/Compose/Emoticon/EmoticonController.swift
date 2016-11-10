//
//  EmoticonController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

// 使用代码注册collectionViewCell的标识
private let EmoticonCell = "EmoticonCell"

class EmoticonController: UIViewController {
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    fileprivate lazy var manager = EmoticonManager()

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK:- 设置UI界面内容
extension EmoticonController {
    fileprivate func setupUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 设置子控件的属性
        collectionView.backgroundColor = UIColor.white
        toolBar.backgroundColor = UIColor.darkGray
        
        // 设置子控件的frame
        // 注意:使用代码约束,一定要将translatesAutoresizingMaskIntoConstraints设置为false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar": toolBar, "collectionView": collectionView] as [String : Any]
        
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        // 准备collectionView
        prepareForCollectionView()
        
        // 准备toolBar
        prepareForToolBar()
    }
    
    fileprivate func prepareForCollectionView() {
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func prepareForToolBar() {
        // 定义toolBar中的titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 遍历标题,创建对应的item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            
            item.tag = index
            index += 1
            
            tempItems.append(item)
            
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 设置toolBar的item数组
        // 删除最后一个flexibel控件
        tempItems.removeLast()
        
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
}

// MARK:- 事件监听
extension EmoticonController {
    @objc fileprivate func itemClick(item: UIBarButtonItem) {
        // 获取点击item的tag
        let tag = item.tag
        
        // 根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: tag)
        
        // 滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK:- collectionView的数据源方法
extension EmoticonController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        
        // 给cell设置数据
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        // 返回cell
        return cell
    }
}

// MARK:- collectionView的代理方法
extension EmoticonController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        // 将点击的表情插入最近分组
        insertRecentlyEmoticon(emoticon: emoticon)
    }
    
    fileprivate func insertRecentlyEmoticon(emoticon: Emoticon) {
        // 如果是空白表情或删除按钮,不需要插入
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        
        // 删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            // 原来有该表情
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        } else {
            // 原来没有该表情,需要移除倒数第二个表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        
        // 将点击的emoticon插入到最近分组中
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
        
        collectionView.reloadData()
    }
}
