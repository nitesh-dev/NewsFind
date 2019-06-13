//
//  ViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Moya
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var downloadedData = [TrendingNewsModel]()
    let images:[UIImage] = [#imageLiteral(resourceName: "aidan-bartos-373657-unsplash"), #imageLiteral(resourceName: "anders-nord-524903-unsplash"), #imageLiteral(resourceName: "daniel-von-appen-375405-unsplash"), #imageLiteral(resourceName: "fancycrave-474441-unsplash"), #imageLiteral(resourceName: "gabriel-sollmann-701262-unsplash"), #imageLiteral(resourceName: "jay-clark-508185-unsplash"), #imageLiteral(resourceName: "john-mark-smith-266552-unsplash"), #imageLiteral(resourceName: "rawpixel-255078-unsplash")]
    let arr:[String] = ["Latest News","Business","Technology","Entertainment","Sports","Science","Health", "Weather"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! FrontCollectionCell
        
        if (cell.imageView.subviews.count == 0)
        {
            let tintView = UIView()
            tintView.backgroundColor = UIColor(white: 0, alpha: 0.4) //change to your liking
            tintView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.imageView.addSubview(tintView)
        }
        cell.layer.cornerRadius = 10
        cell.imageView.image = images[indexPath.row]
        cell.titleLabel.text = arr[indexPath.row]
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.textAlignment = NSTextAlignment.center
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = arr[indexPath.row]
        if text == "Weather"
        {
            let wVC = WeatherViewController(nibName: "WeatherViewController", bundle: nil)
            self.present(wVC, animated: true, completion: nil)
        }
        else
        {
        performSegue(withIdentifier: "cellSelected", sender: text)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSelected" {
            
            if let targetVC = segue.destination as? NewsPageViewController {
                
                if let text = sender as? String {
                    targetVC.newsType = text
                    //targetVC.transitioningDelegate = self
                }
            }
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols: CGFloat = 2
        let col: CGFloat = 1
        let width = collectionView.frame.size.width
        let xinsets: CGFloat = 10
        let cellSpacing: CGFloat = 10
        if(indexPath.row == 0)
        {
            return CGSize(width: (width / col) - (xinsets + cellSpacing) - 10, height: (width / cols))
        }
        else
        {
            return CGSize(width: (width / cols) - (xinsets + cellSpacing), height: (width / cols) - (xinsets + cellSpacing) )
        }
    }
}
//extension ViewController: UIViewControllerTransitioningDelegate
//{
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return FlipAnimationController(originFrame: view.frame )
//    }
//    func animationController(forDismissed dismissed: UIViewController)
//        -> UIViewControllerAnimatedTransitioning? {
//            guard let _ = dismissed as? ViewController else {
//                return nil
//            }
//            return FlipDismissAnimationController(destinationFrame: view.frame)
//    }
//}

