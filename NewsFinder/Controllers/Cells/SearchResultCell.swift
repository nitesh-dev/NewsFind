//
//  SearchResultCell.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 11/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var openLinkBtn: UIButton!
    let newParentView = UIView()
//    var pan: UIPanGestureRecognizer!
//    var deleteLabel1: UILabel!
//    var deleteLabel2: UILabel!
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    func commonInit()
//    {
//        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
//        pan.delegate = self
//        self.addGestureRecognizer(pan)
    
//    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        backImgView.clipsToBounds = true
        self.addSubview(backImgView)
        self.layer.masksToBounds = true
        
        backImgView.snp.makeConstraints {
            make in
            make.top.equalTo(self.snp.top)
            make.height.equalTo(self.snp.height)//.multipliedBy(0.6)
            make.left.right.equalTo(self)
        }
        backImgView.addSubview(newParentView)
        newParentView.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        newParentView.addSubview(dateLabel)
        newParentView.addSubview(loveButton)
        
//        loveButton.snp.makeConstraints{
//            make in
//            make.top.equalTo(newParentView.snp.top).offset(10)
//            make.right.equalTo(newParentView.snp.right).offset(-10)
//        }
        newParentView.snp.makeConstraints{
            make in
            make.bottom.right.left.top.equalTo(backImgView)
        }
        newParentView.addSubview(titleLabel)
        newParentView.addSubview(sourceLabel)
        
        
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(newParentView.snp.left).offset(10)
            make.bottom.equalTo(newParentView.snp.bottom).offset(-10)
            make.right.lessThanOrEqualTo(newParentView.snp.right).offset(-10)
        }
        dateLabel.snp.makeConstraints{
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
            make.bottom.equalTo(dateLabel.snp.top).offset(10)
            make.left.equalTo(newParentView.snp.left).offset(10)
            make.height.equalTo(30)
        }
        
        
        sourceLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        sourceLabel.textColor = UIColor.white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 16)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 3
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)


        dateLabel.font = UIFont(name: "Montserrat-Light", size: 12)
        dateLabel.textColor = UIColor.white
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        if( backImgView.layer.sublayers == nil)
//        {
//            let view = UIView(frame: CGRect(x: backImgView.bounds.origin.x, y: backImgView.bounds.origin.y, width: backImgView.bounds.width + 60, height: backImgView.bounds.height))
//            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            backImgView.addSubview(view)
//            backImgView.bringSubview(toFront: view)
//
//            openLinkBtn.frame = CGRect(x: self.bounds.width / 2 + 11, y: 128, width: 28, height: 28)
//            //            openLinkBtn.center = CGPoint(x: self.bounds.width / 2, y: 128)
//            openLinkBtn.tag = 1
//            openLinkBtn.layer.cornerRadius = openLinkBtn.frame.width / 2
//
////            deleteLabel1 = UILabel()
////            deleteLabel1.text = "delete"
////            deleteLabel1.textColor = UIColor.white
////            self.insertSubview(deleteLabel1, belowSubview: self.contentView)
////
////            deleteLabel2 = UILabel()
////            deleteLabel2.text = "delete"
////            deleteLabel2.textColor = UIColor.white
////            self.insertSubview(deleteLabel2, belowSubview: self.contentView)
//        }
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if (pan.state == UIGestureRecognizerState.changed) {
//            let p: CGPoint = pan.translation(in: self)
//            let width = self.contentView.frame.width
//            let height = self.contentView.frame.height
//            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
//            self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width-10, y: 0, width: 100, height: height)
//            self.deleteLabel2.frame = CGRect(x: p.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
//        }
//
//    }
//
//    @objc func onPan(_ pan: UIPanGestureRecognizer) {
//        if pan.state == UIGestureRecognizerState.began {
//
//        } else if pan.state == UIGestureRecognizerState.changed {
//            self.setNeedsLayout()
//        } else {
//            if abs(pan.velocity(in: self).x) > 500 {
//                let collectionView: UICollectionView = self.superview as! UICollectionView
//                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
//                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
//            } else {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.setNeedsLayout()
//                    self.layoutIfNeeded()
//                })
//            }
//        }
//    }
}


