//
//  SearchOverlayView.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 31/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit

class SearchOverlayView: UIView, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        configure()
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    private func configure()
    {
        Bundle.main.loadNibNamed("FilterOverlayView", owner: self, options: nil)
        addSubview(overlayView)
        overlayView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y  , width: self.bounds.width , height: 70)
        
        let image = self.getImageWithColor(color: UIColor.white, size: CGSize(width: 100, height: 45))
        
        searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        searchBar.frame = CGRect(x: 0, y: 10, width: self.overlayView.bounds.width , height: 50)

        overlayView.backgroundColor = UIColor.init(hexString: "#263238")
        searchBar.delegate = self
        self.searchBar.text = ""
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Cliced")
        let myDict: [String: Any] = ["myText": searchBar.text as Any]
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: myDict)
        self.searchBar.resignFirstResponder()
    }
}
