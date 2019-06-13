//
//  WebViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 29/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var containerView: UIView? = nil
    @IBOutlet weak var nWebView: WKWebView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var urlString : String?
    var sourceStr: String?
    let infoLabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    var blurEffectView = UIVisualEffectView()
    let cancelButton = UIButton()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: nWebView.bounds.width / 2 - 35  , y: nWebView.bounds.height / 2 - 35, width: 80, height: 80), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.red, padding: 0)
    func openNewsInWeb() {
        if let myData = urlString {
            let url = URL(string: myData)
            nWebView.load(URLRequest(url: url!))
        } else {
            print("****")
        }
    }
    @objc func addTapped()
    {
        nWebView.stopLoading()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = sourceStr
        navBar.barTintColor  = UIColor.flatWhite
        navItem.hidesBackButton = false
        navItem.leftBarButtonItem  = UIBarButtonItem(image: UIImage(named:"icons8-left-24"), style: .plain, target: self, action: #selector(addTapped))
        navItem.leftBarButtonItem?.tintColor = UIColor.black
        nWebView = WKWebView(frame: CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y + 60, width: self.view.bounds.width, height: self.view.bounds.height))
        nWebView.translatesAutoresizingMaskIntoConstraints = false
        nWebView.isUserInteractionEnabled = true
        nWebView.navigationDelegate = self
        self.view.addSubview(nWebView)
        
        openNewsInWeb()
        nWebView.backgroundColor = UIColor.clear
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.nWebView.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(blurEffectView)
        
        
        
        
        cancelButton.addTarget(self, action:#selector(self.cancelLoading(_:)), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 10
        
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textColor = UIColor.white
        cancelButton.isUserInteractionEnabled = true
        
        self.view.addSubview(activityIndicatorView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(infoLabel)
        infoLabel.text = "Please wait while we load"
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor.black
        infoLabel.setSizeFont(sizeFont: 18)
        
        infoLabel.snp.makeConstraints {
            make in
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.activityIndicatorView.startAnimating()
        self.nWebView.navigationDelegate = self
        
    }
    @objc func cancelLoading(_ sender: UIButton)
    {
        nWebView.stopLoading()
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        blurEffectView.isHidden = true
        activityIndicatorView.stopAnimating()
        cancelButton.isHidden = true
        infoLabel.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        blurEffectView.isHidden = true
        activityIndicatorView.stopAnimating()
        infoLabel.isHidden = true
    }
}

