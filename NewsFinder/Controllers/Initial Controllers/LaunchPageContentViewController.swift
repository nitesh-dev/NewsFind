//
//  LaunchPageContentViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchPageContentViewController: UIViewController {
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var logoImgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBAction func goToLoginAction(_ sender: Any) {
    }
    let pageIndex: NSInteger = 0
    let titleText: String = ""
    let imageFile: String = ""
    
    func buttonDesign()
    {
        logoLabel.layer.backgroundColor = UIColor.clear.cgColor
        logoLabel.minimumScaleFactor = 0.1
        logoImgView.layer.backgroundColor = UIColor.clear.cgColor
        let cornerRadius : CGFloat = 25.0
        
        startButton.layer.cornerRadius = cornerRadius
        let exampleColor = UIColor.white
        startButton.backgroundColor = exampleColor.withAlphaComponent(0.1)
        startButton.titleLabel?.minimumScaleFactor = 0.3;
        startButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        //startButton.backgroundColor = UIColor.clear
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = UIColor.white.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.launchImageView.image = #imageLiteral(resourceName: "elijah-o-donell-603766-unsplash")
        self.titleLabel.text = "NewsFinder is powered by NewsAPI.com"
        buttonDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
