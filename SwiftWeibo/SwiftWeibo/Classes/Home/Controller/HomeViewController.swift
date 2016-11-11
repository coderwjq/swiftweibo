//
//  HomeViewController.swift
//  SwiftWeibo
//
//  Created by mzzdxt on 2016/10/28.
//  Copyright © 2016年 wjq. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var titleBtn: TitleButton = TitleButton()
    
    // 注意:在闭包中,如果使用当前对象的属性或者调用方法,也需要加上self
    // 两个地方需要使用self:
    // 1.如果在一个函数中出现歧义,需要加上self
    // 2.在闭包中使用当前对象的属性和方法,也需要加上self
    fileprivate lazy var popoverAnimator: WJQPopoverAnimator = WJQPopoverAnimator {[weak self] (isPresented) in
        self?.titleBtn.isSelected = isPresented
    }
    
    fileprivate lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    fileprivate lazy var tipLabel: UILabel = UILabel()
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 没有登录时设置的内容
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
        // 设置导航栏的内容
        setupNavigationBar()
        
        // 设置估算高度
        tableView.estimatedRowHeight = 200
        
        // 布局header和footer
        setupHeaderView()
        setupFooterView()
        
        // 设置提示label
        setupTipLabel()
        
        // 监听通知
        setupNotification()
    }

}

// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        // 设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发微博", style: .plain, target: self, action: #selector(HomeViewController.publishStatus))
        
        // 设置titleView
        titleBtn.setTitle("coderwjq", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    fileprivate func setupHeaderView() {
        // 创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))!
        
        // 设置headerView的属性
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("加载中...", for: .refreshing)
        
        // 设置tableView的header
        tableView.mj_header = header
        
        // 进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupFooterView() {
        tableView.mj_footer = MJRefreshFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }
    
    fileprivate func setupTipLabel() {
        // 将tipLabel添加到导航控制器
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        // 设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        // 设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func publishStatus() {
        // 创建发布控制器
        let composeVc = ComposeViewController()
        
        // 包装导航控制器
        let composeNav = UINavigationController(rootViewController: composeVc)
        
        // 弹出控制器
        present(composeNav, animated: true, completion: nil)
    }
    
    @objc fileprivate func titleBtnClick(titleBtn: TitleButton) {
        // 改变按钮的状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        // 创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        
        // 设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        let width: CGFloat = 180
        let height: CGFloat = 250
        let screenWidth = UIScreen.main.bounds.size.width
        let x: CGFloat = (screenWidth - width) * 0.5
        let y: CGFloat = 55
        popoverAnimator.presentedFrame = CGRect(x: x, y: y, width: width, height: height)
        
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(note: Notification) {
        // 取出数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = note.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        // 创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath: indexPath, picURLs: picURLs)
        
        // 设置Modal样式
        photoBrowserVc.modalPresentationStyle = .custom
        
        // 设置转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        // 设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        // 以modal的形式弹出控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }
}

// MARK:- 请求数据
extension HomeViewController {
    /// 加载最新的数据
    @objc fileprivate func loadNewStatuses() {
        loadStatuses(isNewDate: true)
    }
    
    /// 加载更多的数据
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(isNewDate: false)
    }
    
    /// 加载微博数据
    fileprivate func loadStatuses(isNewDate: Bool) {
        // 获取since_id/max_id
        var since_id = 0
        var max_id = 0
        
        if isNewDate {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.sharedInstance.loadStatuses(since_id: since_id, max_id: max_id, finished: { (result, error) in
            // 错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 获取可选类型中的数据
            guard let resultArray = result as? [[String : AnyObject]] else {
                return
            }
            
            // 遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            // 将数据放入到成员变量的数组中
            if isNewDate {
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels += tempViewModel
            }
            
            // 缓存图片
            self.cacheImages(viewModels: tempViewModel)
        })
    }
    
    /// 缓存图片
    fileprivate func cacheImages(viewModels: [StatusViewModel]) {
        // 创建group
        let group  = DispatchGroup()
        
        // 缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                
                SDWebImageManager.shared().downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        
        // 刷新表格
        group.notify(queue: DispatchQueue.main) { 
            // 刷新表格
            self.tableView.reloadData()
            
            // 停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示提示label
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    /// 显示提示的label
    fileprivate func showTipLabel(count: Int) {
        // 设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博"
        
        // 执行动画
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
            }) { (_) in
                UIView.animate(withDuration: 1.0, animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.isHidden = true
                })
        }
    }
}

// MARK:- tableView的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
        
        // 给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 获取模型对象
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHight
    }
}
