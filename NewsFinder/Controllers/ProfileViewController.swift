//
//  ProfileViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 08/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        signoutBtn.titleLabel?.text = "Signed Out"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateViewController(withIdentifier: "tabMain")
        self.present(initial, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSettings()
        profileTableView.isScrollEnabled = false
    }

    func viewSettings()
    {
        detailView.layer.borderWidth = 3
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: detailView.bounds.width / 2, y: detailView.bounds.width / 4, width: 100, height: 100)
        imgView.center.x = detailView.center.x
        let image = UIImage(named: "jay-clark-508185-unsplash")
        imgView.image = image
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.contentMode = .scaleAspectFill
        detailView.addSubview(imgView)
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = profileTableView.bounds.height / 5
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proCell", for: indexPath)
        cell.textLabel?.text = "Name"
        return cell
    }
    
    
}
