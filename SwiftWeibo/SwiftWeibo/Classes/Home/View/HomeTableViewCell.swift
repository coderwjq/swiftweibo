//
//  HomeTableViewCell.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/4.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15
private let itemMargin: CGFloat = 10

class HomeTableViewCell: UITableViewCell {
    
    // MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verfiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    
    // MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel: StatusViewModel? {
        didSet {
            // 空值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // 设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 设置认证的图标
            verfiedView.image = viewModel.verifiedImage
            
            // 设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            // 设置会员图标
            vipView.image = viewModel.vipImage
            
            // 设置时间的label
            timeLabel.text = viewModel.createdAtText
            
            // 设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
            
            // 设置微博正文
            contentLabel.attributedText = FindEmoticon.sharedInstance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            // 设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            // 根据图片个数计算picView的宽度和高度约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            // 将picURL数据传递给picView
            picView.picURLs = viewModel.picURLs
            
            // 设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                // 有转发微博
                // 设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName): " + retweetedText
                    
                    // 设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                
                // 设置背景显示
                retweetedBgView.isHidden = false
            } else {
                // 没有转发微博
                // 设置转发微博的正文
                retweetedContentLabel.text = nil
                
                // 设置背景显示
                retweetedBgView.isHidden = true
                
                // 设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
            }
            
            // 计算cell的高度并保存
            if viewModel.cellHight == 0 {
                // 强制布局
                layoutIfNeeded()
                
                // 获取底部工具栏的最大Y值
                viewModel.cellHight = bottomToolView.frame.maxY
            }
        }
    }

    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.size.width - 2 * edgeMargin
    }
    
}

// MARK:- 计算方法
extension HomeTableViewCell {
    fileprivate func calculatePicViewSize(count: Int) -> CGSize {
        // 没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        // 有配图需要改约束有值
        picViewBottomCons.constant = 10
        
        // 取出picView对应的Layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 单张配图
        if count == 1 {
            // 取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)!
            
            // 设置一张图片是layout的itemSize
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        
        // 计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 设置其他张图片时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 其他张配图
        // 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        // 返回CGSize
        return CGSize(width: picViewW, height: picViewH)
    }
}
