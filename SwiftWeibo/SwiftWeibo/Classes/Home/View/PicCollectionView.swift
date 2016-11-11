//
//  PicCollectionView.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/7.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SDWebImage

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
        delegate = self
    }
}

// MARK:- collectionView的数据源方法
extension PicCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey: indexPath, ShowPhotoBrowserUrlsKey: picURLs] as [String : Any]
        
        // 发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

// MARK:- 遵守转场动画的代理协议
extension PicCollectionView: AnimatorPresentedDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        // 获取cell
        let cell = self.cellForItem(at: indexPath)!
        
        // 获取cell的item
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        // 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)!
        
        // 计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / image.size.width * image.size.height
        var y: CGFloat = 0
        if y > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - y) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        // 创建UIImageView对象
        let imageView = UIImageView()
        
        // 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}
