//
//  ComposeViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/11/7.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleView: ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images: [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc: EmoticonController = EmoticonController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }

    // MARK:- 约束的属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHCons: NSLayoutConstraint!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏
        setupNavigationBar()
        
        // 监听通知
        setupNotifications()
        
        // 设置代理
        textView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 在界面显示完成后再弹出键盘
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    fileprivate func setupNavigationBar() {
        // 设置左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    fileprivate func setupNotifications() {
        // 监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 监听添加照片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        // 监听删除照片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(note:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}

// MARK:- 事件监听函数
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClick() {
        // 键盘退出
        textView.resignFirstResponder()
        
        // 获取要发送的微博正文
        let statusText = textView.getEmoticonString()
        
        // 定义回调的闭包
        let finishedCallback = { (isSucess: Bool) -> () in
            if !isSucess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
            }
            
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        
        // 获取用户选中的图片
        if let image = images.first {
            NetworkTools.sharedInstance.sendStatus(statusText: statusText, image: image, isSucess: finishedCallback)
        } else {
            NetworkTools.sharedInstance.sendStatus(statusText: statusText, isSucess: finishedCallback)
        }
    }
    
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
        // 获取动画执行的时间
        let duration = (note as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 获取键盘的最终Y值
        let endFrame = ((note as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        // 计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y;
        
        // 执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration, animations: { 
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func picPickerBtnClick() {
        // 退出键盘
        textView.resignFirstResponder()
        
        // 执行动画
        picPickerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func emoticonBtnClick() {
        // 1.退出键盘
        textView.resignFirstResponder()
        
        // 2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        
        // 3.弹出键盘
        textView.becomeFirstResponder()
    }
}

// MARK:- 添加照片和删除照片的事件
extension ComposeViewController {
    @objc fileprivate func addPhotoClick() {
        // 判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        // 创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 设置照片源
        ipc.sourceType = .photoLibrary
        
        // 设置代理
        ipc.delegate = self
        
        // 弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func removePhotoClick(note: Notification) {
        // 获取image对象
        guard let image = note.object as? UIImage else {
            print("未获取到image对象")
            return
        }
        
        // 获取image对象所在的下标值
        guard let index = images.index(of: image) else {
            print("未获取到index")
            return
        }
        
        // 将图片从数组删除
        images.remove(at: index)
        
        // 重新赋值collectionView新的数组
        picPickerView.images = images
    }
}

// MARK:- UIImagePickerController的代理方法
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 将选中图片添加到数组
        images.append(image)
        
        // 将数组赋值给collectionView并展示数据
        picPickerView.images = images
        
        // 退出选中照片的控制器
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITextView的代理方法
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
