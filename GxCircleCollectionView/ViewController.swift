//
//  ViewController.swift
//  GxCircleCollectionView
//
//  Created by cxria on 16/10/13.
//  Copyright © 2016年 yushilive. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArray = [String]()
    @IBOutlet weak var pageControl: UIPageControl!
    var myview:MyView!
    @IBOutlet weak var circleView: GxCircleCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        circleView.regist(cellClass: MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        circleView.dataSource = self
        circleView.delegate = self
        circleView.autoScroll = true
        circleView.scrollDirection = .horizontal
        //circleView.reloadData()
        print("viewdid load")
        pageControl.numberOfPages = 0
        
        
        
        //进行网络请求,实际使用时，还是用Alamofire方便点
        let url = URL.init(string: "http://apis.baidu.com/txapi/mvtp/meinv?num=5")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("7a558db2864fcc30a5b23d4335145ad5", forHTTPHeaderField: "apikey")
        let session = URLSession.shared
        let dataTask =  session.dataTask(with: request) { (data, response, error) in
            print(response)
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            let array = (json as! [String:Any])["newslist"]
            for item in array as! [[String:String]] {
                self.dataArray.append(item["picUrl"]!)
            }
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = self.dataArray.count
                self.circleView.reloadData()
            }
            
            
        }
        dataTask.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:GxCircleCollectionViewDataSource{
    func itemCountOfGxCircleView() -> Int {
        return dataArray.count
    }
    func gxCircleCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        print("\(dataArray[indexPath.row])")
        //设置图片，实际使用时，还是用kingfisher方便点
        DispatchQueue.global().async {
            let url = URL.init(string: self.dataArray[indexPath.row])
            let data = try? Data.init(contentsOf: url!)
            DispatchQueue.main.async {
                if(data == nil){ return }
                cell.myImageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
}
extension ViewController:GxCircleCollectionViewDelegate{
    func gxCircleCollectonView(didScrollToItem index: Int) {
        print("++++++++did scroll to index \(index)++++++")
        
    }
    
    func gxCircleCollectonView(scrollToItem index: Int) {
        print("=====scroll to index \(index)=====")
        pageControl.currentPage = index
    }
    
}
