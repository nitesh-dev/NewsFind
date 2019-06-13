//
//  LoginViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 05/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var loginFB: UIButton!
    @IBAction func loginFBAction(_ sender: Any) {
    }
    @IBAction func signUpaction(_ sender: Any) {
        Auth.auth().signIn(withEmail: mailTF.text!, password: pwdTF.text!) { (user, error) in
            if error == nil{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabMain")
                self.present(newViewController, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func viewSettings()
    {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: loginFB.bounds.origin.x + 10, y: loginFB.bounds.origin.y + 10, width: 40, height: 40)
        let fimage = UIImage(named: "fbicon")
        imageView.image = fimage
        loginFB.addSubview(imageView)
//
//        let image = UIImage(named: "fbicon")?.withRenderingMode(.alwaysTemplate)
//        loginFB.setImage(image, for: .normal)
        loginFB.tintColor = UIColor.init(hexString: "#ffffff")
        //loginFB.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSettings()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
