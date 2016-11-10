//
//  PicPickerViewCell.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/9.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    // MARK:- 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removePhotoBtn: UIButton!
    
    // MARK:- 自定义的属性
    var image: UIImage? {
        didSet {
            if image != nil {
                // 如果有图片就给imageView设置图片
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
            } else {
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removePhotoBtn.isHidden = true
            }
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK:- 事件监听
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func removePhotoClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
    
}
