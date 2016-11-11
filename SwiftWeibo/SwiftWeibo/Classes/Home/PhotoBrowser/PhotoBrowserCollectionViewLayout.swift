//
//  PhotoBrowserCollectionViewLayout.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
}
