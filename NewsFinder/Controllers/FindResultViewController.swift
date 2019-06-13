//
//  FindResultViewController.swift
//  NewsFinder
//
//  Created by Cognizant Technology Solutions # 2 on 11/10/18.
//  Copyright © 2018 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import Moya
import NVActivityIndicatorView
import FirebaseDatabase
import RxSwift

class FindResultViewController: UIViewController, UISearchBarDelegate {

    
    var collectionView: UICollectionView!
    var headerView: SearchHeaderView!
    var headerHeightConstraint: NSLayoutConstraint!
    lazy var customSearchBar:UISearchBar = UISearchBar()
    var flag = false
    let provider = MoyaProvider<EverythingAPI>()
    var res: [TrendingNewsModel]!
    {
        didSet {
            flag = true
        }
    }
    
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: collectionView.bounds.width / 2 , y: collectionView.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor.red, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpCollectionView()
        activityIndicatorView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        view.addSubview(activityIndicatorView)
        
        customSearchBar = UISearchBar()
        customSearchBar.delegate = self
        customSearchBar.frame = CGRect(x: self.headerView.bounds.origin.x + 10 , y: self.headerView.bounds.origin.y + 10, width: UIScreen.main.bounds.width - 20, height: 80)
        customSearchBar.layer.masksToBounds = false
                
        let textFieldInsideSearchBar = customSearchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.white
        customSearchBar.showsCancelButton = true
        customSearchBar.showsBookmarkButton = false
        customSearchBar.searchBarStyle = UISearchBarStyle.minimal
        customSearchBar.barStyle = .default
        customSearchBar.placeholder = "Search for news and events"
        customSearchBar.tintColor = UIColor.white
        customSearchBar.showsSearchResultsButton = false
        self.headerView.addSubview(customSearchBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDataFromAPI(domain: String, query: String, completionHandler: @escaping (Bool) -> Void){
        activityIndicatorView.startAnimating()
        provider.request(.domain(dm: domain, query: query)) { result in
            switch result  {
            case .success(let response):
                do{
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    self.res = try filteredResponse.map([TrendingNewsModel].self, atKeyPath: "articles", using: decoder)
                    print("***")
                    completionHandler(true)
                } catch {
                    print("Exception catched")
                }
            case .failure:
                print("Parsing Error")
                completionHandler(false)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.getDataFromAPI(domain: "nytimes.com" ,query: searchBar.text!, completionHandler:{ result in
            if (result == true)
            {
                self.activityIndicatorView.stopAnimating()
                self.flag = true
                self.collectionView.reloadData()
            }
        })
        self.view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func setUpHeader() {
        headerView = SearchHeaderView(frame: CGRect.zero, title: "")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 101)
        headerHeightConstraint.isActive = true
        let constraints:[NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.bounds.width - 30, height: 161)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: headerView.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height - headerView.bounds.size.height)  , collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        let constraints:[NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        //collectionView.register(SearchResultCell.self,forCellWithReuseIdentifier: "searchCell")
        let nib = UINib(nibName: "SearchResultCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "searchCell")
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
    }
    func animateHeader() {
        self.headerHeightConstraint.constant = 101
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
        }, completion: nil)
    }

}
extension FindResultViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if flag == false
        {
            return 0
        }
        else
        {
            return res.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchResultCell
        if flag == true
        {
            cell.titleLabel.text = res[indexPath.item].title
            cell.sourceLabel.text = res[indexPath.item].source?.name
            cell.dateLabel.text = "11 October, 2018"
            cell.backImgView.imageFromServerURL(res[indexPath.item].urlToImage!, placeHolder: #imageLiteral(resourceName: "rawpixel-255078-unsplash"))
            cell.backImgView.contentMode = .scaleAspectFill
        }
        return cell
    }
}
extension FindResultViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant > 75 {
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y/100
            if self.headerHeightConstraint.constant < 75 {
                self.headerHeightConstraint.constant = 75
            }
            
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
}
