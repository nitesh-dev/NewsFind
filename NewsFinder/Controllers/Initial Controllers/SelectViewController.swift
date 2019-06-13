//
//  SelectViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

class SelectViewController: UIViewController
{
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    let storyboardx = UIStoryboard(name: "Login", bundle: nil)
    @IBAction func openSignupPage(_ sender: Any) {
        let nextViewController = storyboardx.instantiateViewController(withIdentifier: "signuppage") as! SignupViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func openLoginPage(_ sender: Any) {
        let nextViewController = storyboardx.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let pview = UIView()
        pview.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.width, height: self.view.bounds.height)
        pview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.insertSubview(pview, at: 1)
    }
}
