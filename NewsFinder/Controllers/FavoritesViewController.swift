//
//  FavoritesViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 13/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Moya
import NVActivityIndicatorView
import FirebaseDatabase
import Firebase
class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var cardBackgroundView = UIView()
    var arrModel = [FirebaseDictToModel]()
    
    var realmTempNews : [RealmNews]?
    var collectionView: UICollectionView!
    var headerView: SearchHeaderView!
    var headerHeightConstraint: NSLayoutConstraint!
    lazy var customSearchBar:UISearchBar = UISearchBar()
    var flag = false
    var stateIndex: Int = 0
    let provider = MoyaProvider<EverythingAPI>()
    var indexIterator = 0
    var res: [FirebaseDictToModel]!
    {
        didSet {
            flag = true
        }
    }
    let bottomLeftButton = UIButton(type: .custom)
    let bottomRightButton = UIButton(type: .custom)
    
    enum position {
        case bottomRight
        case bottomLeft
        case bottomMiddle
    }
    
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: collectionView.bounds.width / 2 , y: collectionView.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor.red, padding: 0)
    var reference: DatabaseReference?
    var databaseHandler: DatabaseHandle?
    
    
    @objc func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        
        let point = longPressGR.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            var cell = self.collectionView.cellForItem(at: indexPath)
            print(indexPath.row)
        } else {
            print("Could not find index path")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHeader()
        self.getFavCardsFromFirebase(completionHandler:{ result in
            if (result == true)
            {
                if self.arrModel.count > 0
                {
                    self.flag = true
                    self.collectionView.reloadData()
                }
            }
        })
        
        self.reloadAfterDelete(completionHandler :{ result in
            if (result == true)
            {
                //self.activityIndicatorView.stopAnimating()
                if self.arrModel.count >= 0
                {
                    self.flag = true
                    self.collectionView.reloadData()
                }
            }
        })
        
        
        setUpCollectionView()
        activityIndicatorView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        view.addSubview(activityIndicatorView)
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFavCardsFromFirebase(completionHandler: @escaping (Bool) -> Void){
        //activityIndicatorView.startAnimating()
        let userID : String = (Auth.auth().currentUser?.uid)!
        reference = Database.database().reference().child("users").child(userID).child("userFavData")
        databaseHandler = reference?.observe(.childAdded, with: { (snapshot) in
            
            var title: String, source: String, desc: String, url: String, urlImg: String, date: String
            let card = snapshot.value as? [String: String]
            if let actualCard = card {
                title = actualCard["title"]!
                source = actualCard["source"]!
                if(( actualCard["description"]) != nil)
                { desc = actualCard["description"]! }
                else
                { desc = "No description available" }
                url = actualCard["url"]!
                if (( actualCard["urlImage"]) != nil)
                { urlImg = actualCard["urlImage"]! }
                else
                { urlImg = "" }
                date = actualCard["date"]!
                let object = FirebaseDictToModel(title: title, desc: desc, date: date, imgURL: urlImg, url: url, source: source)
                self.arrModel.append(object)
                completionHandler(true)
            }
        })
    }
    func reloadAfterDelete(completionHandler: @escaping (Bool) -> Void){
        let userID : String = (Auth.auth().currentUser?.uid)!
        reference = Database.database().reference().child("users").child(userID).child("userFavData")
        databaseHandler = reference?.observe(.childRemoved, with: { (snapshot) in
            var title: String, source: String, desc: String, url: String, urlImg: String, date: String
            let card = snapshot.value as? [String: String]
            if let actualCard = card {
                title = actualCard["title"]!
                source = actualCard["source"]!
                if(( actualCard["description"]) != nil)
                { desc = actualCard["description"]! }
                else
                { desc = "No description available" }
                url = actualCard["url"]!
                if (( actualCard["urlImage"]) != nil)
                { urlImg = actualCard["urlImage"]! }
                else
                { urlImg = "" }
                date = actualCard["date"]!
                let object = FirebaseDictToModel(title: title, desc: desc, date: date, imgURL: urlImg, url: url, source: source)
                
                if let idx = self.arrModel.index(where: { $0.url == object.url }) {
                    self.arrModel.remove(at: idx)
                }
                completionHandler(true)
            }
        })
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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
        
        let height = UIScreen.main.bounds.height / 4.5
        layout.itemSize = CGSize(width: self.view.bounds.width - 30, height: height)
        
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
            return arrModel.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchResultCell
        if flag == true
        {
            cell.titleLabel.text = arrModel[indexPath.item].title
            cell.sourceLabel.text = arrModel[indexPath.item].source
            cell.dateLabel.text = arrModel[indexPath.item].date
            if arrModel[indexPath.item].imgURL != ""
            {
                cell.backImgView.imageFromServerURL(arrModel[indexPath.item].imgURL!, placeHolder: #imageLiteral(resourceName: "rawpixel-255078-unsplash"))
            }
            else
            {
                cell.backImgView.image = #imageLiteral(resourceName: "rawpixel-255078-unsplash")
            }
            cell.backImgView.contentMode = .scaleAspectFill
            cell.loveButton.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = NewsCardDetailViewController(nibName: "NewsCardDetailViewController", bundle: nil)
        controller.cardDelegate = self
        controller.favDictModelNews = arrModel[indexPath.item]

        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        newsCardViewInit(indexPath: indexPath)
    }
    private func newsCardViewInit(indexPath: IndexPath)
    {
        cardBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        cardBackgroundView.frame = self.view.frame
        
        let controller = NewsCardDetailViewController(nibName: "NewsCardDetailViewController", bundle: nil)
        controller.cardDelegate = self
        controller.favDictModelNews = self.arrModel[indexPath.item]
        controller.isFavViewController = true
        let mainViewHeight = view.bounds.height * 0.75
        let yPad = view.bounds.height * 0.125
        controller.view.layer.cornerRadius = 15
        controller.view.clipsToBounds = true
        controller.view.layer.masksToBounds = true
        
        self.view.insertSubview(cardBackgroundView, aboveSubview: self.view)
        self.cardBackgroundView.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        controller.view.addGestureRecognizer(swipeRight)
//
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        controller.view.addGestureRecognizer(swipeDown)
        controller.view.isUserInteractionEnabled = true
        
        controller.view.snp.makeConstraints {
            make in
            make.height.equalTo(mainViewHeight)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.view.snp.top).offset(yPad)
        }
        
//        cardBackgroundView.addSubview(favButton)
        cardBackgroundView.addSubview(bottomLeftButton)
        cardBackgroundView.addSubview(bottomRightButton)
        
        stateIndex = indexPath.row
        let cont = NewsDetailContainer()
        cont.createOuterButtons(bottomLeftButton, cview: controller.view, position: .bottomLeft)
        cont.createOuterButtons(bottomRightButton, cview: controller.view, position: .bottomRight)
        //cont.createOuterButtons(favButton, cview: controller.view, position: .bottomMiddle)
        //favButton.addTarget(self, action:#selector(self.makeFavorite(_:)), for: .touchUpInside)
        //bottomLeftButton.addTarget(self, action:#selector(self.openInWebView(_:)), for: .touchUpInside)
    }
    
}
extension FavoritesViewController :UIScrollViewDelegate {
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
extension FavoritesViewController: CloseCardViewDelegate {
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
    }
    
}
