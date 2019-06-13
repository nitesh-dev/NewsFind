//
//  FirstCollectionCell.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 23/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit

class FirstCollectionCell: UICollectionViewCell {
    //@IBOutlet weak var bigImgView: UIImageView!
    let sourceLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self)
        }
        sourceLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        sourceLabel.textColor = UIColor.white
        sourceLabel.textAlignment = .center
    }
}
