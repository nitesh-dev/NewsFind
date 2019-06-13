//
//  TagCollectionCell.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 18/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

class TagCollectionCell: UICollectionViewCell {
    var imageView = UIImageView()
    var imageFrontView = UIView()
    var titleLabel = UILabel()
    var tagLabel = UILabel()
    var tagImage = UIImageView()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView = UIImageView(image: UIImage(named: "rawpixel-255078-unsplash"))
        self.addSubview(imageView)
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            make in
            make.top.bottom.right.left.equalTo(self)
        }
        imageFrontView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.addSubview(imageFrontView)
        
        
        imageFrontView.snp.makeConstraints {
            make in
            make.top.bottom.right.left.equalTo(imageView)
        }
        
        imageFrontView.addSubview(titleLabel)
        imageFrontView.addSubview(tagLabel)
        titleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(imageFrontView.snp.top).offset(20)
            make.height.equalTo(40)
            make.left.equalTo(imageFrontView.snp.centerX).offset(-100)
            make.width.equalTo(200)
        }
        tagImage.image = UIImage(named: "icons8-hash-30")
        imageFrontView.addSubview(tagImage)
        
        tagImage.image = tagImage.image!.withRenderingMode(.alwaysTemplate)
        tagImage.tintColor = UIColor.white
        tagImage.snp.makeConstraints {
            make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.width.equalTo(40)
            make.centerX.equalTo(imageFrontView.snp.centerX)
        }
        tagLabel.snp.makeConstraints {
            make in
            make.top.equalTo(tagImage.snp.bottom)
            make.bottom.lessThanOrEqualTo(imageFrontView.snp.bottom).offset(-20)
            make.centerX.equalTo(imageFrontView.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(400)
        }
        tagLabel.textColor = UIColor.white
        tagLabel.numberOfLines = 0
        tagLabel.lineBreakMode = .byWordWrapping
        tagLabel.sizeToFit()
        tagLabel.font = UIFont(name: "Montserrat-Regular", size: 16)
      
        titleLabel.textColor = UIColor.white
        titleLabel.setSizeFont(sizeFont: 20)
        titleLabel.textAlignment = .center
        tagLabel.textAlignment = .center
    }
}
