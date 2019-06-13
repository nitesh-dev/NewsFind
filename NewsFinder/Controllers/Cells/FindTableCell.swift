//
//  FindTableCell.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 25/09/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Moya
class FindTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let provider = MoyaProvider<TrendingAPI>()
    var sources = ["nytimes.com", "washingtonpost.com","bbc.com", "wsj.com", "cnn.com"]
    var flag = false
    var selectedIn: Int = 0
    var sres: [SourceModel]!
    {
        didSet {
            flag = true
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "findCell", for: indexPath) as! FindCollectionCell
        cell.layer.cornerRadius = 5
        var string = ""
        
        string = "https://logo.clearbit.com/" + sources[indexPath.item]
        
        cell.titleImgView.imageFromServerURL(string, placeHolder: nil)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
