//
//  PhotoBrowserController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/11.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    
    // MARK:- 定义属性
    var indexPath: IndexPath
    var picURLs: [URL]
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    fileprivate lazy var saveBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")

    // MARK:- 自定义构造函数
    init(indexPath: IndexPath, picURLs: [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
        
        // 滚动到对应的图片
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

}

// MARK:- 设置UI界面
extension PhotoBrowserController {
    fileprivate func setupUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 设置子控件的frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        // 设置collectionView的属性
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        // 监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
}

// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClick() {
        // 获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 将iamge对象保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:error:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(image: UIImage, error: NSError?, contextInfo: Any) {
        var showInfo = ""
        
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存失败"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

// MARK:- 实现collectionView的数据源方法
extension PhotoBrowserController: UICollectionViewDataSource {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
        // 给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

// MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserController: PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

// MARK:- 遵守
extension PhotoBrowserController: AnimatorDismissDelegate {
    func indexPathForDismissView() -> IndexPath {
        // 获取当前正在显示的indexPath
        let cell = collectionView.visibleCells.first!
        
        return collectionView.indexPath(for: cell)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        // 创建UIImageView对象
        let imageView = UIImageView()
        
        // 设置imageView的frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        // 设置imageView的属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}
