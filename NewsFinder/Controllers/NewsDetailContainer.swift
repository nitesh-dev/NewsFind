//
//  NewsDetailContainer.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 14/01/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailContainer {
    let cardBackgroundView = UIView()
    let bottomLeftButton = UIButton(type: .custom)
    let bottomRightButton = UIButton(type: .custom)
    let favButton = UIButton(type: .custom)
    //    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    //    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    var articleId = ""
    enum position {
        case bottomRight
        case bottomLeft
        case bottomMiddle
    }
    
    
    func newsCardViewInit(articleId: String, passedView: UIView, controller: UIViewController) -> UIView
    {
        
        //self.changeConfigBtn.isHidden = true
        cardBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        cardBackgroundView.frame = passedView.frame
        self.articleId = articleId
        //        let controller = NewsCardDetailViewController(nibName: "NewsCardDetailViewController", bundle: nil)
        //        controller.cardDelegate = cont
        //        controller.data = self.filteredItemsByNewsType?[indexPath.row]
        let mainViewHeight = passedView.bounds.height * 0.75
        let yPad = passedView.bounds.height * 0.125
        controller.view.layer.cornerRadius = 15
        controller.view.clipsToBounds = true
        controller.view.layer.masksToBounds = true
        
        passedView.addSubview(cardBackgroundView)
        self.cardBackgroundView.addSubview(controller.view)
        cardBackgroundView.isUserInteractionEnabled = true
        passedView.isUserInteractionEnabled = true
        controller.view.isUserInteractionEnabled = true
        
        //        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //        controller.view.addGestureRecognizer(swipeRight)
        //
        //
        //        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        //        controller.view.addGestureRecognizer(swipeDown)
        
        controller.view.snp.makeConstraints {
            make in
            make.height.equalTo(mainViewHeight)
            make.right.equalTo(passedView.snp.right).offset(-25)
            make.left.equalTo(passedView.snp.left).offset(25)
            make.top.equalTo(passedView.snp.top).offset(yPad)
        }
        favButton.isUserInteractionEnabled = true
        favButton.addTarget(self, action:#selector(self.makeFavorite(_:)), for: .touchUpInside)
        //createOuterButtons(bottomLeftButton, cview: controller.view, position: .bottomLeft)
        //createOuterButtons(bottomRightButton, cview: controller.view, position: .bottomRight)
        //createOuterButtons(favButton, cview: controller.view, position: .bottomMiddle)
        
        return cardBackgroundView
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func createOuterButtons(_ button: UIButton, cview: UIView, position: position)
    {
        
        //cardBackgroundView.addSubview(button)
        button.clipsToBounds = true
        button.backgroundColor = UIColor.lightGray
        button.addBlurEffect()
        button.snp.makeConstraints {
            make in
            switch position
            {
            case .bottomLeft:
                make.left.equalTo(cview.snp.left).offset(20)
                make.top.equalTo(cview.snp.bottom).offset(20)
                make.height.equalTo(50)
                make.width.equalTo(50)
                
            case .bottomRight:
                make.right.equalTo(cview.snp.right).offset(-20)
                make.top.equalTo(cview.snp.bottom).offset(20)
                make.height.equalTo(50)
                make.width.equalTo(50)
                
                
            case .bottomMiddle:
                make.top.equalTo(cview.snp.bottom).offset(20)
                make.height.equalTo(60)
                make.width.equalTo(60)
                make.centerX.equalTo(cview.snp.centerX)
            }
        }
        switch position {
        case .bottomLeft:
            button.layer.cornerRadius = 25
            let btnImage = UIImage(named: "icons8-geography-filled-32")?.withRenderingMode(.alwaysTemplate)
            button.tintColor = UIColor.white
            button.setImage(btnImage , for: UIControlState.normal)
            
        case .bottomRight:
            button.layer.cornerRadius = 25
            let btnImage = UIImage(named: "icons8-share-filled-32")?.withRenderingMode(.alwaysTemplate)
            button.tintColor = UIColor.white
            button.setImage(btnImage , for: UIControlState.normal)
            
        case .bottomMiddle:
            button.layer.cornerRadius = 30
            let btnImage = UIImage(named: "icons8-heart-outline-filled-50")?.withRenderingMode(.alwaysTemplate)
            button.tintColor = UIColor.white
            button.setImage(btnImage , for: UIControlState.normal)
            button.isUserInteractionEnabled = true
        }
    }
   @objc func makeFavorite(_ sender: UIButton)
    {
        print(articleId)
    }
}
