//
//  NewsFilterMainView.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 10/09/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit
class NewsFilterMainView: UIView
{
    override func draw(_ rect: CGRect) {
        var frame = CGRect()
        frame = self.bounds
        UIColor.clear.set()
        UIRectFill(frame)
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: bounds.origin.y , width: bounds.width, height: bounds.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
