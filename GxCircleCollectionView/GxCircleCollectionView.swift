//
//  GxCircleCollectionView.swift
//  GxCircleCollectionView
//
//  Created by cxria on 16/10/13.
//  Copyright © 2016年 yushilive. All rights reserved.
//

import UIKit

class GxCircleCollectionView: UIView {

    // MARK: - subviews
    var collectionView:UICollectionView!
    var collectionViewFlowLayout:UICollectionViewFlowLayout!
    
    
    
    // MARK: - 初始化
    override  init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews(){
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewFlowLayout.scrollDirection = self.scrollDirection
        self.collectionViewFlowLayout.minimumLineSpacing = 0
        self.collectionViewFlowLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        self.collectionViewFlowLayout.itemSize = self.bounds.size
        
        if let totalCount = self.dataSource?.itemCountOfGxCircleView() {
            guard totalCount > 0 else { return }
            let indexPath = IndexPath.init(row: totalCount*itemCountMultiples/2 , section: 0)
            //没有.none供选择，直接init（0）
            self.collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0)
                , animated: false)
           // currentIndex = totalCount*itemCountMultiples/2
        }
    }
    // MARK: - 自定义属性
    weak var dataSource:GxCircleCollectionViewDataSource?
    weak var delegate :GxCircleCollectionViewDelegate?
    
    /// collectionview的item count = itemCountMultiples * datasource提供的item count。
    var itemCountMultiples = 200
    
    
    private var timer:Timer?
    ///滚动的方向
    var scrollDirection:UICollectionViewScrollDirection = .horizontal {
        willSet {
            self.collectionViewFlowLayout.scrollDirection = newValue
        }
    }
    ///轮播时间间隔, 先设置interval，再开启autoScroll = true
    var timerInterval = 3.0
    ///是否自动滚动
    var autoScroll = false {
        willSet {
            if(newValue == true){//设置为自动滚动
                self.setupTimer()
            }else{//取消自动滚动
                self.invalidateTimer()
            }
        }
    }
    var currentItemIndex = -1
    //在collection view中的index
    private var currentIndex:Int {
        get{
            if(self.collectionView.bounds.width == 0 || self.collectionView.bounds.height == 0) { return 0 }
            var index = 0
            let itemSize = self.collectionViewFlowLayout.itemSize
            if(self.collectionViewFlowLayout.scrollDirection == .horizontal){
            index = Int(Float(self.collectionView.contentOffset.x + itemSize.width * 0.5) / Float(itemSize.width))
            }else{
             index = Int(Float(self.collectionView.contentOffset.y + itemSize.height * 0.5) / Float(itemSize.height))
            }
            return index
        }
    }
//        {
//        willSet{
//            guard let _dataSource = self.dataSource else {
//                return
//            }
//            //值没变，直接返回
//            if(currentIndex == newValue){ return }
//            self.delegate?.gxCircleCollectonView?(scrollToItem: newValue%_dataSource.itemCountOfGxCircleView())
//        }
//    }
    // MARK: - cell相关方法
    // 注册cell
    func regist(cellClass:AnyClass?, forCellWithReuseIdentifier:String){
       self.collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func regist(nib:UINib?, forCellWithReuseIdentifier:String){
        self.collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    /// reload data，并滚动到中间
    func reloadData(){
        self.collectionView.reloadData()
        if let totalCount = self.dataSource?.itemCountOfGxCircleView() {
            guard totalCount > 0 else { return }
            let indexPath = IndexPath.init(row: totalCount*itemCountMultiples/2 , section: 0)
            //没有.none供选择，直接init（0）
            self.collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0)
                , animated: false)
        }
    }
    //滚动到下一页
    func scrollToNextPage(){
        let nextPageIndex = self.currentIndex + 1
        self.scrollToPage(index: nextPageIndex)
    }
    
    func scrollToPage(index:Int){
        guard let _dataSource = self.dataSource else { return }
        let totalCount = itemCountMultiples * _dataSource.itemCountOfGxCircleView()
        if(totalCount == 0){ return }
        if(index >= totalCount){
            let targetIndex = itemCountMultiples / 2 * _dataSource.itemCountOfGxCircleView()
            let indexPath = IndexPath.init(row: targetIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
        }else{
            let indexPath = IndexPath.init(row: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        }
    }

    
    // MARK: - 设置和取消定时器
    private func invalidateTimer(){
        if let _timer = self.timer {//如果有之前设置了定时器，那么取消掉
            _timer.invalidate()
            self.timer = nil
        }
    }
    private func setupTimer(){
        if let _timer = self.timer {//如果有之前设置了定时器，那么取消掉
            _timer.invalidate()
            self.timer = nil
        }else{//重新设置
            self.timer = Timer.scheduledTimer(timeInterval:timerInterval , target: self, selector: #selector(GxCircleCollectionView.scrollToNextPage), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .commonModes)
        }
    }
    
    // MARK: - scrollview代理方法
    
    //只要动了就通知滚到哪了
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let _dataSource = self.dataSource else {
            return
        }
        let itemIndex = self.currentIndex%_dataSource.itemCountOfGxCircleView()
        if(self.currentItemIndex != itemIndex){
            self.currentItemIndex = itemIndex
            self.delegate?.gxCircleCollectonView?(scrollToItem: itemIndex)
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(self.autoScroll == true){
            self.invalidateTimer()
        }
    }
 
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(self.autoScroll == true){
            self.setupTimer()
        }
    }
    // 在此处发送scrolltoindex的通知，避免快速滑动时，发送无意义的通知。
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let _dataSource = self.dataSource else { return }
        if(_dataSource.itemCountOfGxCircleView() == 0){ return }
        self.delegate?.gxCircleCollectonView?(didScrollToItem: self.currentIndex%_dataSource.itemCountOfGxCircleView())
    }

}

extension GxCircleCollectionView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _delegate = self.delegate {
            _delegate.gxCircleCollectionView?(collectionView, didSelectItemAt: indexPath)
        }
    }
}


extension GxCircleCollectionView:UICollectionViewDataSource{
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _dataSource = self.dataSource {
            return itemCountMultiples * _dataSource.itemCountOfGxCircleView()
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _dataSource = self.dataSource {
            let rawIndexParh = IndexPath.init(row: indexPath.row%_dataSource.itemCountOfGxCircleView(), section: 0)
            return _dataSource.gxCircleCollectionView(collectionView, cellForItemAt: rawIndexParh)
        }else{
            return UICollectionViewCell()
        }
    }

}



protocol GxCircleCollectionViewDataSource:NSObjectProtocol {
    func itemCountOfGxCircleView()->Int
    func gxCircleCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

@objc protocol  GxCircleCollectionViewDelegate:NSObjectProtocol{
    /** 点击了某个item **/
    @objc optional func gxCircleCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    /** 这个只有开始减速时才反馈，会忽略快速滑动时经过的item **/
    @objc optional func gxCircleCollectonView(didScrollToItem index:Int)
    /** 这个每次滑动都会反馈  **/
    @objc optional func gxCircleCollectonView(scrollToItem index:Int)
}
