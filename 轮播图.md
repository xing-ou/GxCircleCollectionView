一直想自己实现一个轮播图，最近闲下来了，赶紧搞一个。

因为之前遇到需要定制轮播view的情况，目前的好多轮播图，都只是轮播一个图片或图片加文字。所以这次我将轮播view的定制给了用户来定义，当然这就决定了要用collectionview来实现这个轮播图。

#### 效果图

![](http://xingou.oss-cn-shanghai.aliyuncs.com/hehe.gif)

#### 怎么用？

怎么用collectionview就怎么用这个

```swift
//先注册cell
circleView.regist(cellClass: MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//设置datasource和delegate
circleView.dataSource = self
circleView.delegate = self
//设置属性
circleView.timerInterval = 3.0
circleView.autoScroll = true
===============================================
//发起网络请求，请求得到数据后reloadData()
circleView.reloadData()
```

#### datasource

```swift
protocol GxCircleCollectionViewDataSource:NSObjectProtocol {
	///总共有多少个
    func itemCountOfGxCircleView()->Int
    ///每个cell显示什么内容
    func gxCircleCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
```

#### delegate

```swift
@objc protocol  GxCircleCollectionViewDelegate:NSObjectProtocol{
    /** 点击了某个item **/
    @objc optional func gxCircleCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    /** 这个只有开始减速时才反馈，会忽略快速滑动时经过的item **/
    @objc optional func gxCircleCollectonView(didScrollToItem index:Int)
    /** 这个每次滑动都会反馈 , 用于关联pageControl之类的控件做出相关反应 **/
    @objc optional func gxCircleCollectonView(scrollToItem index:Int)
}
```

#### demo地址





