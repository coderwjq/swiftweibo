//
//  EmoticonCollectionViewLayout.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/10.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

/* 自定义瀑布流布局 */

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        // 设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
    
}
