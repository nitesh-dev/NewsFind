//
//  NewsPageViewController+Extension.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 19/05/19.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension NewsPageViewController: AddToFirebaseDelegate, DeleteFromFirebaseDelegate, NewsFilterDelegate {
    func btnFavTapped(cell: NewsCollectionCell, id: String) {
        let indexPath = self.trendingCollectionView.indexPath(for: cell)
        print(indexPath!.row)
        databaseRefer = Database.database().reference()
        
        let newPosts: Dictionary<String, AnyObject> = [
            "title" : res[(indexPath?.row)!].title as AnyObject,
            "description" : res[(indexPath?.row)!].description as AnyObject,
            "urlImage" : res[(indexPath?.row)!].urlToImage as AnyObject,
            "url" : res[(indexPath?.row)!].url as AnyObject,
            "source" : res[(indexPath?.row)!].source?.name as AnyObject,
            "date" : res[(indexPath?.row)!].publishedAt as AnyObject
        ]
        print("Unique Id is %@", id)
        let userID : String = (Auth.auth().currentUser?.uid)!
        databaseRefer.child("users").child(userID).child("userFavData").child(id).setValue(newPosts)
    }
    
    func btnFavUntapped(cell: NewsCollectionCell, id: String) {
        cell.delegateRem = self
        let indexPath = self.trendingCollectionView.indexPath(for: cell)
        print(indexPath!.row)
        //databaseRefer = Database.database().reference().child("Favorites").child(id)
        let userID : String = (Auth.auth().currentUser?.uid)!
        databaseRefer = Database.database().reference().child("users").child(userID).child("userFavData").child(id)
        databaseRefer?.removeValue(completionBlock: {(error, ref) in
            if error != nil {
                print("There was an error in removing the current username\(String(describing: error?.localizedDescription))")
            } else {
                print("The child was removed")
            }
        })
    }
    func displayIndicator()
    {
        let viewWidth = self.view.bounds.size.width / 2
        let viewHeight = self.view.bounds.size.height / 2
        indicatorView.frame = CGRect(x: viewWidth - 50, y: viewHeight - 50, width: 100, height: 100)
        indicatorView.layer.cornerRadius = 10
        
        indicatorView.layer.shadowColor = UIColor.init(hexString: "#263238")?.cgColor
        indicatorView.layer.shadowOffset = CGSize(width: 3, height: 3)
        indicatorView.layer.shadowOpacity = 0.7
        indicatorView.layer.shadowRadius = 4.0
        
        indicatorView.clipsToBounds = true
        indicatorView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = indicatorView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        indicatorView.addSubview(blurEffectView)
        
        
        indicatorView.addSubview(refreshActivityIndicatorView)
        self.view.addSubview(indicatorView)
        refreshActivityIndicatorView.startAnimating()
    }
    func finishPassing(country: String, category: String) {
        
        concurrentQueue.async(flags: .barrier) {
            print(country)
            if (!(country == "Select Country") && !(category == "Select Category"))
            {
                let downloadManager = DownloadManager()
                downloadManager.getDataFromAPI(code: country, category: category.lowercased(), query: "",completionHandler:{ result in
                    switch result
                    {
                    case .success:
                        var resultPredicate = NSPredicate()
                        if category.lowercased() == ""
                        {
                            resultPredicate = NSPredicate(format: "country = %@", country.lowercased())
                        }
                        else
                        {
                            resultPredicate = NSPredicate(format: "newsType = %@ AND country = %@", self.newsType.lowercased(), country.lowercased())
                        }
                        print(self.filteredItemsByNewsType!)
                        self.filteredItemsByNewsType = self.realm.objects(RealmNews.self).filter(resultPredicate).sorted(byKeyPath: "publishedAt", ascending: false).distinct(by: ["title"])
                        print(self.filteredItemsByNewsType!)
                        self.trendingCollectionView.reloadData()
                        self.indicatorView.removeFromSuperview()
                        self.refreshActivityIndicatorView.stopAnimating()
                    case .failure:
                        self.indicatorView.removeFromSuperview()
                        self.refreshActivityIndicatorView.stopAnimating()
                        print("Error occured, please try again later")
                    case .catchFailure : print("error")
                    }
                })
            }
            else
            {
                print("No parameters")
            }
        }
        
        DispatchQueue.main.async {
            self.displayIndicator()
        }
    }
}
extension NewsPageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = changeConfigBtn.center
        transition.circleColor = UIColor.clear
        return transition
        //        guard let _ = dismissed as? NewsPageViewController else {
        //            return nil
        //        }
        //        return FlipDismissAnimationController(destinationFrame: view.frame)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = changeConfigBtn.center
        transition.circleColor = UIColor.clear
        return transition
    }
}

extension NewsPageViewController: CloseCardViewDelegate {
    func closeCardView() {
        
        if self.childViewControllers.count > 0{
            let viewControllers:[UIViewController] = self.childViewControllers
            for viewContoller in viewControllers{
                viewContoller.willMove(toParentViewController: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParentViewController()
            }
        }
        for views in cardBackgroundView.subviews {
            views.removeFromSuperview()
        }
        self.cardBackgroundView.removeFromSuperview()
        self.changeConfigBtn.isHidden = false
   }
    
}

