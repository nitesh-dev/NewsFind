//
//  SecondViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 09/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1.0
        
//        logoLabel.frame = CGRect(x: 0, y: -20, width: 130, height: 110)
//        logoLabel.textColor = UIColor.black
//        logoImgView.addSubview(logoLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
