//
//  PicPickerCollectionView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/9.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin: CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    // MARK:- 定义属性
    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        
        // 设置collectionView的属性
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        // 设置collectionView的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: edgeMargin, right: edgeMargin)
    }
    
}

// MARK:- 数据源代理方法
extension PicPickerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        
        // 给cell设置数据
        cell.backgroundColor = UIColor.red
        cell.image = (indexPath as NSIndexPath).item <= images.count - 1 ? images[(indexPath as NSIndexPath).item] : nil
        
        // 返回cell
        return cell
    }
}
