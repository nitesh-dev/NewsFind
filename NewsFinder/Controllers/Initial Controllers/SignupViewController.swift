//
//  SignupViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignupViewController: UIViewController {

    @IBOutlet weak var loginH: NSLayoutConstraint!
    @IBOutlet weak var signupH: NSLayoutConstraint!
    @IBOutlet weak var pwdH: NSLayoutConstraint!
    @IBOutlet weak var nameH: NSLayoutConstraint!
    @IBOutlet weak var mailH: NSLayoutConstraint!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var loginFB: UIButton!
    var databaseRef: DatabaseReference?
    var databaseHandler: DatabaseHandle?
    @IBAction func signUpFirebase(_ sender: Any) {
        databaseRef = Database.database().reference()
        Auth.auth().createUser(withEmail: emailTF.text!, password: pwdTF.text!){ (user, error) in
            if error == nil {
                let credArr = [self.emailTF.text, self.pwdTF.text]
                let userID : String = (Auth.auth().currentUser?.uid)!
                self.databaseRef?.child("users").child(userID).setValue(credArr)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let modelName = UIDevice.modelName
        var pad: CGFloat = 0
        var width: CGFloat = 40
        var height: CGFloat = 40
        if(modelName.contains("SE") || modelName.contains("4") || modelName.contains("5"))
        {
            nameH.constant = 45
            mailH.constant = 45
            pwdH.constant = 45
            signupH.constant = 45
            loginH.constant = 45
            pad = 6.5
            width = 32
            height = 32
        }
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: loginFB.bounds.origin.x + pad, y: loginFB.bounds.origin.y + pad, width: width, height: height)
        let fimage = UIImage(named: "fbicon")
        imageView.image = fimage
        loginFB.addSubview(imageView)
        //
        //        let image = UIImage(named: "fbicon")?.withRenderingMode(.alwaysTemplate)
        //        loginFB.setImage(image, for: .normal)
        loginFB.tintColor = UIColor.init(hexString: "#ffffff")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
