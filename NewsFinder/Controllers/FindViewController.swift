//
//  FindViewController.swift
//  NewsFinder
//
//  Created by Cognizant Technology Solutions # 2 on 13/09/18.
//  Copyright © 2018 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import Moya
import NVActivityIndicatorView

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    @IBOutlet weak var findTableView: UITableView!
    let provider = MoyaProvider<TrendingAPI>()
    var flag = false
    var loadingView = UIView()
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: loadingView.bounds.width / 2 , y: loadingView.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor.red, padding: 0)
    var res: [SourceModel]!
    {
        didSet {
            flag = true
        }
    }
    private var state: viewState = .loading {
        didSet {
            switch state {
            case .ready:
                activityIndicatorView.stopAnimating()
                //collectionView.reloadData()
                loadingView.removeFromSuperview()
                print("Hllo")
                let cell = FindTableCell()
                cell.sres = res
            case .loading:
                activityIndicatorView.startAnimating()
                print("loading")
                print("**")
            case .error:
                print("******")
            }
        }
    }
    enum viewState {
        case loading
        case ready
        case error
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
        return "Search By Sources"
        }
        else
        {
        return "Search By Category"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? FindTableCell
        {
            cell.selectedIn = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findTableView.separatorStyle = .none
        
        loadingView.frame = self.view.bounds
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            loadingView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.loadingView.addSubview(blurEffectView)
        } else {
            loadingView.backgroundColor = .black
        }
        loadingView.isHidden = false
        view.addSubview(loadingView)
        activityIndicatorView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.loadingView.addSubview(activityIndicatorView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.state = .loading
        provider.request(.source) { result in
            switch result  {
            case .success(let response):
                do{
                    print(response)
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    self.res = try filteredResponse.map([SourceModel].self, atKeyPath: "sources", using: decoder)
                    self.state = .ready
                    print("***")
                } catch {
                    print("***")
                }
            case .failure:
                print("****")
            }
        }
    }
  
    
}
