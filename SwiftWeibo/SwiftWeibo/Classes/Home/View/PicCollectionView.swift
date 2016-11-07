//
//  PicCollectionView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/7.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    // MARK:- 定义属性
    var picURLs: [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }

    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }
}

// MARK:- collectionView的数据源方法
extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        // 给cell设置数据
        cell.picURL = picURLs[(indexPath as NSIndexPath).item]
        
        return cell
    }
}
