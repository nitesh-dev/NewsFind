//
//  NewsPageViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 24/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Moya
import ChameleonFramework
import NVActivityIndicatorView
import Hero
import FirebaseDatabase
import Firebase
import RealmSwift

class NewsPageViewController: UIViewController {
    
    // MARK: Variables Declaration
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let provider = MoyaProvider<TrendingAPI>()
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: loadingView.bounds.width / 2 , y: loadingView.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.init(hexString: "#263238"), padding: 0)
    let refreshActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 15, y: 15, width: 70, height: 70), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.init(hexString: "#263238"), padding: 0)
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    
    let categories = ["Business","Entertainment","Sports","Technology", "Science", "General", "Health"]
    var tagCategoryDict = [String: [String]]()
    
    var databaseRefer: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var posts: [String: AnyObject] = [String: AnyObject]()
    let refreshControl = UIRefreshControl()
    var flag = false
    let pview = UIView()
    var selectedSegmentedText = "Local"
    var customSC = UISegmentedControl()
    var newsType = ""
    let backView = UIView()
    let indicatorView = UIView()
    var isSearching = false
    let transition = CircularTransition()
    var refreshFromInside = false
    static var isFirstLoad = true
    static var newsDict = [String: Bool]()
    static var count = 0
    var filteredItemsByNewsType: Results<RealmNews>?
    var realmItem = [TrendingNewsModel]()
    let realm = try! Realm()
    var cardBackgroundView = UIView()
    var selectedId = ""
    let tagCollectionViewIdentifier = "tagCollectionView"
    let tagCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var collectionTimer = Timer()
    var wPad: CGFloat = 0.0
    
    let bottomLeftButton = UIButton(type: .custom)
    let bottomRightButton = UIButton(type: .custom)
    let favButton = UIButton(type: .custom)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    
    var stateIndex: Int = 0
    var res: [TrendingNewsModel]!
    {
        didSet {
            flag = true
        }
    }
    var searchRes: [TrendingNewsModel] = []
    {
        didSet {
            refreshControl.isEnabled = false
            refreshControl.isHidden = true
            isSearching = true
        }
    }
    private var state: viewState = .loading {
        didSet {
            switch state {
            case .ready:
                activityIndicatorView.stopAnimating()
                self.loadingView.isHidden = true
                flag = true
                isSearching = false
                trendingCollectionView.reloadData()
            case .loading:
                activityIndicatorView.startAnimating()
                self.view.bringSubview(toFront: loadingView)
                print("loading")
                print("**")
            case .search:
                searchFunc()
            case .searchReady:
                flag = false
                trendingCollectionView.reloadData()
                pview.removeFromSuperview()
                
            case .error:
                print("******")
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: Enums
    enum viewState {
        case loading
        case ready
        case error
        case search
        case searchReady
    }
    
    enum position {
        case bottomRight
        case bottomLeft
        case bottomMiddle
    }
    
    // MARK: Outlets Declaration
    @IBOutlet weak var changeConfigBtn: UIButton!
    @IBOutlet weak var searchView: SearchOverlayView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    let loadingView = UIView()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var titleText: UILabel!
    // MARK: IBActions Declaration
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func filterBtnAction(_ sender: Any) {
        searchView.isHidden = false
        subViewConfig()
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        trendingCollectionView.isUserInteractionEnabled = true
        tagCollectionViewSettings()
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                self.trendingCollectionView.refreshControl = self.refreshControl
            } else {
                self.trendingCollectionView.addSubview(self.refreshControl)
            }
            self.refreshControl.addTarget(self, action: #selector(self.refreshNewsData(_:)), for: .valueChanged)
            
            self.changeConfigBtnSettings()
        }
        
        DispatchQueue.main.async {
            self.viewSettings()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name:NSNotification.Name(rawValue: "refresh"), object: nil)
        
        titleText.text = newsType
        if newsType == "Latest News" {
            newsType = "general"
        }
        print(newsType)
        state = .loading
        //Getting news data based on current newstype
        let model = NewsPageModel()
        filteredItemsByNewsType = model.readyData(newsType: newsType)
        //Checking if data is there, then updating the view
        
        let tagGenerator = HashtagComposer()
        if (!(filteredItemsByNewsType?.isEmpty)!)
        {
            categories.forEach({ (newsCategory) in
                var filterNews: Results<RealmNews>?
                filterNews = model.readyData(newsType: newsCategory.lowercased())
                let titleArray = Array(filterNews!).filter( {$0.newsType == newsCategory.lowercased()}).flatMap { $0.title}
                
                let tags = tagGenerator.iterateThroughTitlesForTags(for: titleArray)
                tagCategoryDict[newsCategory] = tags
            })
            state = .ready
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configAutoscrollTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        deconfigAutoscrollTimer()
    }
    
    // MARK: Custom Constraints
    func tagCollectionViewSettings()
    {
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        tagCollectionView.isPagingEnabled = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 180, height: 100)
        tagCollectionView.setCollectionViewLayout(layout, animated: true)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.backgroundColor = UIColor.white
        tagCollectionView.register(TagCollectionCell.self, forCellWithReuseIdentifier: tagCollectionViewIdentifier)
        
        self.view.addSubview(tagCollectionView)
        
        searchView.snp.makeConstraints{
            make in
            make.top.equalTo(self.view.snp.top).offset(20)
            make.left.right.equalTo(self.view)
            make.height.equalTo(67)
        }
        let tagCollectionHeight = UIScreen.main.bounds.height / 4
        tagCollectionView.snp.makeConstraints{
            make in
            make.top.equalTo(self.searchView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(tagCollectionHeight)
        }
        trendingCollectionView.snp.makeConstraints {
            make in
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
    }
    
    func configAutoscrollTimer()
    {
        collectionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.autoScrollView), userInfo: nil, repeats: true)
    }
    func deconfigAutoscrollTimer()
    {
        collectionTimer.invalidate()
    }
    func onTimer()
    {
        autoScrollView()
    }
    @objc func autoScrollView()
    {
        let initailPoint = CGPoint(x: wPad,y :0)
        if self.tagCollectionView.contentOffset.x > 1400.0 {
            collectionTimer.invalidate()
        }
        if (__CGPointEqualToPoint(initailPoint, self.tagCollectionView.contentOffset))
        {
            if (wPad < tagCollectionView.contentSize.width)
            {
                wPad += 0.5
            }
            else
            {
                wPad = -self.view.frame.size.width
            }
            
            let offsetPoint = CGPoint(x: wPad,y :0)
            tagCollectionView.contentOffset = offsetPoint
        }
        else
        {
            wPad = tagCollectionView.contentOffset.x
        }
    }
    
    @objc func changeSearchScope(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegmentedText = "Local"
        case 1:
            selectedSegmentedText = "Global"
        default:
            selectedSegmentedText = "Local"
        }
    }
    
    @objc func pressed()
    {
        backView.removeFromSuperview()
        searchView.isHidden = true
        customSC.removeFromSuperview()
        collectionViewTop.constant = 101
        if isSearching == true {
            refreshControl.isEnabled = false
            refreshControl.isHidden = true
            self.state = .ready
        }
    }
    
    // MARK: Instance Methods
    
    func subViewConfig()
    {
        backView.frame = CGRect(x: 0, y: self.view.bounds.origin.y, width: self.view.bounds.width, height: 60)
        backView.backgroundColor = UIColor.init(hexString: "#263238")
        view.addSubview(backView)
        let label = UILabel()
        label.frame = CGRect(x: backView.bounds.width / 2, y: backView.bounds.height / 2 , width: 100, height: 30)
        label.text = "Search"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)!
        label.center = CGPoint(x: backView.bounds.size.width  / 2,
                               y: backView.bounds.size.height / 2 + 20)
        backView.addSubview(label)
        
        let button = UIButton()
        
        let image = UIImage(named: "icons8-go-back-50")
        let tintedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.white
        button.frame = CGRect(x: 15,y: 30, width: 30, height: 30)
        button.addTarget(self, action:#selector(self.pressed), for: .touchUpInside)
        backView.addSubview(button)
        searchView.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 67)
        searchView.backgroundColor = UIColor.init(hexString: "#263238")
        
        view.addSubview(searchView)
        
        let items = ["Local", "Global"]
        customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: searchView.bounds.size.width / 2 - 125, y:  searchView.searchBar.bounds.size.height + 77, width: 250, height: 30)
        customSC.layer.cornerRadius = 7
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor.init(hexString: "#263238")
        customSC.addTarget(self, action: #selector(self.changeSearchScope(sender:)), for: .valueChanged)
        view.addSubview(customSC)
        
        collectionViewTop.constant = 170
    }
    
    func viewSettings()
    {
        // Button Settings
        let image = UIImage(named: "icons8-go-back-50.jpg")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(image, for: .normal)
        backBtn.tintColor = UIColor.white
        let imageF = UIImage(named: "icons8-search-property-50")?.withRenderingMode(.alwaysTemplate)
        filterBtn.setImage(imageF, for: .normal)
        filterBtn.tintColor = UIColor.white
        
        // Loading View Blurred
        let viewWidth = self.view.bounds.size.width / 2
        let viewHeight = self.view.bounds.size.height / 2
        loadingView.frame = CGRect(x: viewWidth - 50, y: viewHeight - 50, width: 100, height: 100)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            loadingView.backgroundColor = .white
            
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.loadingView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.loadingView.addSubview(blurEffectView)
        } else {
            loadingView.backgroundColor = .black
        }
        self.view.addSubview(loadingView)
        // Indicator Settings
        mainView.backgroundColor = UIColor.init(hexString: "#263238")
        trendingCollectionView.backgroundColor = GradientColor(.radial, frame: trendingCollectionView.frame, colors: [UIColor.flatWhite, UIColor.flatWhite])
        self.loadingView.addSubview(activityIndicatorView)
    }
    
    func changeConfigBtnSettings()
    {
        changeConfigBtn.backgroundColor = UIColor.init(hexString: "#263238")
        changeConfigBtn.frame = CGRect(x: self.view.bounds.width - 70, y: self.view.bounds.height - 70, width: 60, height: 60)
        let image = UIImage(named: "icons8-filter-50")?.withRenderingMode(.alwaysTemplate)
        changeConfigBtn.setImage(image, for: .normal)
        changeConfigBtn.imageEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 10)
        changeConfigBtn.layer.cornerRadius = 30.0
        changeConfigBtn.clipsToBounds = true
        changeConfigBtn.layer.shadowColor = UIColor.white.cgColor
        changeConfigBtn.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        changeConfigBtn.layer.shadowOpacity = 1.0
        changeConfigBtn.layer.shadowRadius = 0.4
        changeConfigBtn.tintColor = UIColor.white
        changeConfigBtn.layer.borderColor = UIColor.white.cgColor
        changeConfigBtn.addTarget(self, action: #selector(self.openNewView), for: .touchUpInside)
        mainView.addSubview(changeConfigBtn)
    }
    
    
    // MARK: Refresh Logic
    @objc private func refreshNewsData(_ sender: Any) {
        let code = Locale.current.regionCode?.lowercased()
        if newsType == "Latest News" {
            newsType = "general"
        }
        refreshFromInside = true
        let dmg = DownloadManager()
        dmg.getDataFromAPI(code: code!, category: newsType.lowercased(), query: "",completionHandler:{ result in
            
            switch result {
            case .success:
                if self.refreshFromInside == true && self.isSearching == false
                {
                    let resultPredicate = NSPredicate(format: "newsType = %@", self.newsType.lowercased())
                    self.filteredItemsByNewsType = self.realm.objects(RealmNews.self).filter(resultPredicate).sorted(byKeyPath: "publishedAt", ascending: false).distinct(by: ["title"])
                    self.trendingCollectionView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error): print(error)
            case .catchFailure : print("Please try again")
            }
        })
    }
    
    @objc func refreshList(notification: NSNotification){
        searchRes = []
        if let myDict = notification.object as? [String: Any] {
            if let myText = myDict["myText"] as? String {
                
                if (selectedSegmentedText == "Local")
                {
                    state = .search
                    reloadView(text: myText)
                }
                else
                {
                    refreshControl.isEnabled = false
                    refreshControl.isHidden = true
                    isSearching = true
                    self.res = nil
                }
            }
        }
    }
    func searchFunc()
    {
        refreshControl.isEnabled = false
        pview.frame = CGRect(x: self.trendingCollectionView.bounds.origin.x, y: self.trendingCollectionView.bounds.origin.y, width: self.trendingCollectionView.bounds.size.width, height: self.trendingCollectionView.bounds.size.height)
        pview.backgroundColor = UIColor.white
        pview.addSubview(activityIndicatorView)
        activityIndicatorView.center = CGPoint(x: trendingCollectionView.bounds.width / 2, y: trendingCollectionView.bounds.height / 2)
        activityIndicatorView.startAnimating()
        self.trendingCollectionView.addSubview(pview)
    }
    
    func reloadView(text: String)
    {
        var flag = false
        for obj in res
        {
            if let title = obj.title    {
                if(title.containsIgnoringCase(find: text))
                {
                    flag = true
                    searchRes.append(obj)
                    print("found")
                }
            }
            if flag == false
            {
                if let desc = obj.description{
                    
                    if( desc.containsIgnoringCase(find: text))
                    {
                        searchRes.append(obj)
                        print("found1")
                        flag = false
                    }
                }
            }
        }
        self.state = .searchReady
    }
    
    // MARK: Filter View Transition
    @objc func openNewView()
    {
        let destination = NewsFilterViewController(nibName: "NewsFilterViewController", bundle: nil)
        destination.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        destination.modalPresentationStyle = .overFullScreen
        destination.viewHeight = self.view.bounds.height / 2
        destination.viewWidth = self.view.bounds.width - 100
        destination.delegate = self
        
        DispatchQueue.main.async {
            self.present(destination, animated: true, completion: nil)
        } 
    }
}

extension NewsPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Data Source And Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tagCollectionView {
            return categories.count
        }
        else
        {
            if( flag == true)
            {
                return filteredItemsByNewsType!.count
            }
            else if (isSearching == true)
            {
                return searchRes.count
            }
            else if (NewsPageViewController.isFirstLoad == false)
            {
                return (filteredItemsByNewsType?.count)!
            }
            else
            {
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.tagCollectionView
        {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: tagCollectionViewIdentifier, for: indexPath) as! TagCollectionCell
            cellA.titleLabel.text = categories[indexPath.item]
            let tagString = tagCategoryDict[categories[indexPath.item]]?.joined(separator:"  ")
            cellA.tagLabel.text = tagString
            return cellA
        }
        if collectionView == self.trendingCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! NewsCollectionCell
            if isSearching == true {
                cell.configurations()
                cell.fillData(searchRes[indexPath.row], index: indexPath.row)
                cell.addButtonTapAction = {
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewController
                    nextViewController.urlString = self.searchRes[indexPath.row].url
                    nextViewController.sourceStr = self.searchRes[indexPath.row].source?.name
                    self.present(nextViewController, animated:true, completion:nil)
                }
            }
            if (NewsPageViewController.isFirstLoad == false || flag == true)
            {
                if let items = filteredItemsByNewsType {
                    cell.configurations()
                    print(items[indexPath.row])
                    cell.fillDataFromRealmDatabase(items[indexPath.row], index: indexPath.row)
                    cell.addButtonTapAction = {
                        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewController
                        nextViewController.urlString = items[indexPath.row].url
                        nextViewController.sourceStr = items[indexPath.row].source?.name
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                }
            }
            else
            {
                cell.configurations()
            }
            
            cell.delegate = self
            cell.delegateRem = self
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
            cell.hero.id = "heroView"
            return cell
        }
        return UICollectionViewCell.init()
    }
    
    private func newsCardViewInit(indexPath: IndexPath)
    {
        self.changeConfigBtn.isHidden = true
        cardBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        cardBackgroundView.frame = self.view.frame
        
        let controller = NewsCardDetailViewController(nibName: "NewsCardDetailViewController", bundle: nil)
        controller.cardDelegate = self
        controller.data = self.filteredItemsByNewsType?[indexPath.row]
        
        let mainViewHeight = view.bounds.height * 0.75
        let yPad = view.bounds.height * 0.125
        controller.view.layer.cornerRadius = 15
        controller.view.clipsToBounds = true
        controller.view.layer.masksToBounds = true
        
        self.view.insertSubview(cardBackgroundView, aboveSubview: self.view)
        self.cardBackgroundView.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        controller.view.addGestureRecognizer(swipeRight)
        
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        controller.view.addGestureRecognizer(swipeDown)
        controller.view.isUserInteractionEnabled = true
        
        controller.view.snp.makeConstraints {
            make in
            make.height.equalTo(mainViewHeight)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.view.snp.top).offset(yPad)
        }
        
        cardBackgroundView.addSubview(favButton)
        cardBackgroundView.addSubview(bottomLeftButton)
        cardBackgroundView.addSubview(bottomRightButton)
        
        stateIndex = indexPath.row
        let cont = NewsDetailContainer()
        cont.createOuterButtons(bottomLeftButton, cview: controller.view, position: .bottomLeft)
        cont.createOuterButtons(bottomRightButton, cview: controller.view, position: .bottomRight)
        cont.createOuterButtons(favButton, cview: controller.view, position: .bottomMiddle)
        favButton.addTarget(self, action:#selector(self.makeFavorite(_:)), for: .touchUpInside)
        bottomLeftButton.addTarget(self, action:#selector(self.openInWebView(_:)), for: .touchUpInside)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @objc func makeFavorite(_ sender: UIButton)
    {
        databaseRefer = Database.database().reference()
        let newPosts: Dictionary<String, AnyObject> = [
            "title" : filteredItemsByNewsType![stateIndex].title as AnyObject,
            "description" : filteredItemsByNewsType![stateIndex].descr as AnyObject,
            "urlImage" : filteredItemsByNewsType![stateIndex].urlToImage as AnyObject,
            "url" : filteredItemsByNewsType![stateIndex].url as AnyObject,
            "source" : filteredItemsByNewsType![stateIndex].source!.name as AnyObject,
            "date" : filteredItemsByNewsType![stateIndex].publishedAt as AnyObject
        ]
        let userID : String = (Auth.auth().currentUser?.uid)!
        let id = ShortCodeGenerator.getCode(length: 10)
        databaseRefer.child("users").child(userID).child("userFavData").child(id).setValue(newPosts)
        favButton.tintColor = UIColor.red
    }
    
    @objc func openInWebView(_ sender: UIButton)
    {
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewController
        nextViewController.urlString = self.filteredItemsByNewsType![stateIndex].url
        nextViewController.sourceStr = self.filteredItemsByNewsType![stateIndex].source?.name
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.tagCollectionView {
            let cardVC = storyBoard.instantiateViewController(withIdentifier: "cardVC") as! CardViewController
            cardVC.newsType = categories[indexPath.item]
            self.present(cardVC, animated: true, completion: nil)
        }
        else {
            newsCardViewInit(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.tagCollectionView
        {
            return CGSize(width: collectionView.bounds.width * 0.60 , height: collectionView.bounds.height - 30)
        }
        else
        {
            let cellsAcross: CGFloat = 1
            var widthRemainingForCellContent = collectionView.bounds.width
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
            }
            let cellWidth = widthRemainingForCellContent / cellsAcross
            let modelName = UIDevice.modelName
            if(modelName.contains("SE") || modelName.contains("4") || modelName.contains("5"))
            {
                return CGSize(width: cellWidth, height: collectionView.bounds.height / 2)
            }
            else
            {
                return CGSize(width: cellWidth, height: collectionView.bounds.height / 3)
            }
        }
    }
}
