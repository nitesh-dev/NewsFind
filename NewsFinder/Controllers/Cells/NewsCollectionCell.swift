//
//  NewsCollectionCell.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 24/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Hero
import ChameleonFramework
import SnapKit

protocol AddToFirebaseDelegate: AnyObject {
    func btnFavTapped(cell: NewsCollectionCell, id: String)
}
protocol DeleteFromFirebaseDelegate: AnyObject {
    func btnFavUntapped(cell: NewsCollectionCell, id: String)
}
class NewsCollectionCell: UICollectionViewCell {
    let newParentView = UIView()
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deteLabel: UILabel!
    let images:[UIImage] = [#imageLiteral(resourceName: "aidan-bartos-373657-unsplash"), #imageLiteral(resourceName: "anders-nord-524903-unsplash"), #imageLiteral(resourceName: "daniel-von-appen-375405-unsplash"), #imageLiteral(resourceName: "fancycrave-474441-unsplash"), #imageLiteral(resourceName: "gabriel-sollmann-701262-unsplash"), #imageLiteral(resourceName: "jay-clark-508185-unsplash"), #imageLiteral(resourceName: "john-mark-smith-266552-unsplash")]
    let mview = UIView()
    let imageview = UIImageView()
    weak var delegate: AddToFirebaseDelegate?
    weak var delegateRem: DeleteFromFirebaseDelegate?
    var firebaseID: String? = nil
    var firstSelectionStatus = false
    //let textContainerView = UIView()
    let colors = [UIColor.black, UIColor.blue, UIColor.green, UIColor.gray, UIColor.red, UIColor.brown]
    
    @IBOutlet weak var cornerImgView: UIImageView!
    @IBAction func detailBtnClicked(_ sender: Any) {
        addButtonTapAction?()
    }
    
    @IBAction func loveButtonClicked(_ sender: Any) {
        let randomID = ShortCodeGenerator.getCode(length: 10)
        
        if firstSelectionStatus == false
        {
            firebaseID = randomID
            firstSelectionStatus = true
            delegate?.btnFavTapped(cell: self, id: firebaseID!)
            loveButton.tintColor = UIColor.red
            loveButton.backgroundColor = UIColor.clear
            
            mview.backgroundColor = UIColor.clear
            
            
            imageview.image = UIImage(named: "loveview")
            imageview.frame = CGRect(x: bounds.size.width / 2 + 5, y: bounds.size.height / 2 - 25, width: 50, height: 50)
            
            //parentView.addSubview(imageview)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [.curveEaseInOut , .allowUserInteraction],
                           animations: {
                            self.imageview.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            },
                           completion: { finished in
                            self.imageview.isHidden = true
            })
            
        }
        else
        {
            firstSelectionStatus = false
            let id = firebaseID
            delegateRem?.btnFavUntapped(cell: self, id: id!)
            loveButton.tintColor = UIColor.white
            loveButton.backgroundColor = UIColor.clear
        }
    }
    var addButtonTapAction : (()->())?
    
    var xPad : CGFloat = 0
    var yPad : CGFloat = 0
    var i = 0
    func configurations()
    {
        //parentView.layer.shadowRadius = 5.0
        
        let image = UIImage(named: "icons8-love-32")?.withRenderingMode(.alwaysTemplate)
        loveButton.setImage(image, for: .normal)
        loveButton.tintColor = UIColor.flatWhite
        loveButton.layer.cornerRadius = loveButton.frame.width / 2
        
    }
    func fillData(_ article: TrendingNewsModel, index: Int)
    {
        sourceLabel.text = article.source?.name
        titleLabel.text = article.title
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        let string = article.publishedAt
        let df = DateFormatter()
        let dateString = df.convertDate(string!)
        
        deteLabel.text = dateString
        if let art = article.urlToImage
        {
            // imgView.imageFromServerURL(art, placeHolder: nil)
        }
        else
        {
            if( index >= 5)
            {
                let inde = index % 5
                //imgView.image = images[inde]
            }
            else
            {
                //imgView.image = images[index]
            }
        }
    }
    func fillDataFromRealmDatabase(_ article: RealmNews, index: Int)
    {
        sourceLabel.text = article.source?.name
        sourceLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        sourceLabel.textColor = UIColor.white
        titleLabel.text = article.title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 16)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 3
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        let string = article.publishedAt
        let df = DateFormatter()
        let dateString = df.convertDate(string!)
        
        deteLabel.text = dateString
        deteLabel.font = UIFont(name: "Montserrat-Light", size: 12)
        deteLabel.textColor = UIColor.white
        if let art = article.urlToImage
        {
            let random = Int(arc4random_uniform(UInt32(images.count)))
            cornerImgView.imageFromServerURL(art, placeHolder: images[random])
            cornerImgView.contentMode = .scaleAspectFill
        }
        else
        {
            if( index >= 5)
            {
                let inde = index % 5
                //imgView.image = images[inde]
                cornerImgView.image = images[inde]
                cornerImgView.contentMode = .scaleAspectFill
            }
            else
            {
                //imgView.image = images[index]
                cornerImgView.image = images[index]
                cornerImgView.contentMode = .scaleAspectFill
            }
        }
    }
}
extension NewsCollectionCell: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipAnimationController(originFrame: self.frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        cornerImgView.clipsToBounds = true
        self.addSubview(cornerImgView)
        self.layer.masksToBounds = true
        
        cornerImgView.snp.makeConstraints {
            make in
            make.top.equalTo(self.snp.top)
            make.height.equalTo(self.snp.height)//.multipliedBy(0.6)
            make.left.right.equalTo(self)
        }
        cornerImgView.addSubview(newParentView)
        newParentView.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        newParentView.addSubview(deteLabel)
        newParentView.addSubview(loveButton)
        
        loveButton.snp.makeConstraints{
            make in
            make.top.equalTo(newParentView.snp.top).offset(10)
            make.right.equalTo(newParentView.snp.right).offset(-10)
        }
        newParentView.snp.makeConstraints{
            make in
            make.bottom.right.left.top.equalTo(cornerImgView)
        }
        newParentView.addSubview(titleLabel)
        newParentView.addSubview(sourceLabel)
        
        
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(newParentView.snp.left).offset(10)
            make.bottom.equalTo(newParentView.snp.bottom).offset(-10)
            make.right.lessThanOrEqualTo(newParentView.snp.right).offset(-10)
        }
        deteLabel.snp.makeConstraints{
            make in
            make.left.equalTo(newParentView.snp.left).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.equalTo(titleLabel.snp.top).offset(10)
        }
        let topOffsetForSourceLabel = self.bounds.height * 0.25
        sourceLabel.snp.makeConstraints {
            make in
            make.top.greaterThanOrEqualTo(newParentView.snp.top).offset(topOffsetForSourceLabel)
            make.bottom.equalTo(deteLabel.snp.top).offset(10)
            make.left.equalTo(newParentView.snp.left).offset(10)
            make.height.equalTo(30)
            
        }
    }
}


