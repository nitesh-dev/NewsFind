//
//  CardViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 19/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SnapKit

class CardViewController: UIViewController, AddToFirebaseDelegate, DeleteFromFirebaseDelegate{
    func btnFavTapped(cell: NewsCollectionCell, id: String) {
        //
    }
    
    func btnFavUntapped(cell: NewsCollectionCell, id: String) {
        //
    }
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var filteredItemsByNewsType: Results<RealmNews>?
    private var realmSourceItems: Results<RealmSource>?
    var realmItem = [TrendingNewsModel]()
    let realm = try! Realm()
    var realmItems: Results<RealmNews>?
    var newsType: String = ""
    let barImageView = UIImageView()
    let barTranslucentView = UIView()
    let slidingCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    let slidingCollectionViewIdentifier = "slidingCell"
    let navigationTitle = UILabel()
    let backButton = UIButton()
    var cardBackgroundView = UIView()
    
    let passedNewsType: String = ""
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCardCollectionView()
        setSlidingCollectionView()
        
        let code = Locale.current.regionCode?.lowercased()
        let resultPredicate = NSPredicate(format: "newsType = %@ AND country = %@", newsType.lowercased(), code!)
        filteredItemsByNewsType = realm.objects(RealmNews.self).filter(resultPredicate).sorted(byKeyPath: "publishedAt", ascending: false).distinct(by: ["title"])
        
        let sourcePredicate = NSPredicate(format: "category = %@ AND country = %@", newsType.lowercased(), code!)
        realmSourceItems = realm.objects(RealmSource.self).filter(sourcePredicate).sorted(byKeyPath: "name", ascending: false).distinct(by: ["name"])
        
        

        
        
    }
    
    private func setCardCollectionView()
    {
        setNavigationBar()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let barHeight = self.view.bounds.height * 0.20
        cardCollectionView.snp.makeConstraints {
            make in
            make.top.equalTo(barHeight)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.view.addSubview(barImageView)
        barImageView.image = #imageLiteral(resourceName: "rawpixel-255078-unsplash")
        self.barImageView.addSubview(barTranslucentView)
        barTranslucentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        barImageView.contentMode = .scaleAspectFill
        barImageView.clipsToBounds = true
        barImageView.snp.makeConstraints {
            make in
            make.right.left.top.equalTo(self.view)
            make.bottom.equalTo(self.cardCollectionView.snp.top).offset(-10)
        }
        barTranslucentView.snp.makeConstraints {
            make in
            make.bottom.top.left.right.equalTo(self.barImageView)
        }
        
        backButton.snp.makeConstraints {
            make in
            make.top.equalTo(barTranslucentView.snp.top).offset(20)
            make.left.equalTo(barTranslucentView.snp.left).offset(15)
            make.height.width.equalTo(40)
        }
        navigationTitle.snp.makeConstraints {
            make in
            make.top.equalTo(barTranslucentView.snp.top).offset(20)
            make.centerX.equalTo(barTranslucentView.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        navigationTitle.textAlignment = .center
        backButton.layer.cornerRadius = backButton.constraints[0].constant / 2
        backButton.clipsToBounds = true
        backButton.isUserInteractionEnabled = true
        barImageView.isUserInteractionEnabled = true
        barTranslucentView.isUserInteractionEnabled = true
    }
    
    private func setNavigationBar()
    {
        barTranslucentView.addSubview(navigationTitle)
        barTranslucentView.addSubview(backButton)
        barTranslucentView.clipsToBounds = true
        backButton.layer.masksToBounds = true
        navigationTitle.text = newsType
        navigationTitle.textColor = UIColor.white
        navigationTitle.setSizeFont(sizeFont: 20)
        
        let origImage = UIImage(named: "icons8-go-back-50");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = UIColor.white
        
        backButton.addTarget(self, action:#selector(popThisViewController( sender:)), for: .touchUpInside)
    }
    @objc func popThisViewController(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    private func setSlidingCollectionView()
    {
        layout.scrollDirection = .horizontal
        slidingCollectionView.isPagingEnabled = true
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //layout.itemSize = CGSize(width: 180, height: 100)
        slidingCollectionView.setCollectionViewLayout(layout, animated: true)
        slidingCollectionView.delegate = self
        slidingCollectionView.dataSource = self
        slidingCollectionView.backgroundColor = UIColor.clear
        slidingCollectionView.register(FirstCollectionCell.self, forCellWithReuseIdentifier: slidingCollectionViewIdentifier)
        slidingCollectionView.showsHorizontalScrollIndicator = false
        self.view.insertSubview(slidingCollectionView, aboveSubview: barTranslucentView)
        slidingCollectionView.snp.makeConstraints {
            make in
            make.bottom.equalTo(barTranslucentView.snp.bottom).offset(-5)
            make.left.right.equalTo(self.view)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(60)
        }
        let cvWidth = slidingCollectionView.frame.width
        let cvHeight = slidingCollectionView.frame.height
        let cellEdge = cvWidth / 3
        let contentSize = cellEdge * CGFloat(10)
        slidingCollectionView.backgroundColor = UIColor.white
        slidingCollectionView.contentSize = CGSize(width: contentSize + 200, height: cvHeight)
    }
}
extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 5);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cardCollectionView
        {
            return (filteredItemsByNewsType?.count)!
        }
        else if collectionView == self.slidingCollectionView
        {
            return (realmSourceItems?.count)!
        }
        else
        {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.slidingCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: slidingCollectionViewIdentifier, for: indexPath) as! FirstCollectionCell
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            cell.layer.cornerRadius = 5
            cell.sourceLabel.text = realmSourceItems![indexPath.row].name
            return cell
        }
        if collectionView == self.cardCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! NewsCollectionCell
            
            if let items = filteredItemsByNewsType {
                cell.configurations()
                print(items[indexPath.row])
                cell.fillDataFromRealmDatabase(items[indexPath.row], index: indexPath.row)
            }
            cell.delegate = self
            cell.delegateRem = self
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
            cell.hero.id = "heroView"
            return cell
        }
        
        return UICollectionViewCell.init()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cardCollectionView
        {
            let controller = NewsCardDetailViewController(nibName: "NewsCardDetailViewController", bundle: nil)
            controller.cardDelegate = self
            controller.data = self.filteredItemsByNewsType?[indexPath.row]
            
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
            let container = NewsDetailContainer()
            let cardView = container.newsCardViewInit(articleId: filteredItemsByNewsType![indexPath.row].id, passedView: self.view, controller: controller)
            cardBackgroundView = cardView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.slidingCollectionView
        {
            return CGSize(width: collectionView.bounds.width * 0.30 , height: collectionView.bounds.height * 0.80)
        }
        else
        {
            let cellsAcross: CGFloat = 1
            var widthRemainingForCellContent = collectionView.bounds.width
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
            }
            let cellWidth = widthRemainingForCellContent / cellsAcross
            let modelName = UIDevice.modelName
            if(modelName.contains("SE") || modelName.contains("4") || modelName.contains("5"))
            {
                return CGSize(width: cellWidth, height: collectionView.bounds.height / 2.5)
            }
            else
            {
                return CGSize(width: cellWidth, height: 153.0)
            }
        }
    }
}
extension CardViewController: CloseCardViewDelegate {
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
