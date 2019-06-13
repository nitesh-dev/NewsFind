//
//  NewsCardDetailViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 03/09/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.

import UIKit
import SnapKit
import Hero
import ChameleonFramework
protocol CloseCardViewDelegate: AnyObject {
    func closeCardView()
}
class NewsCardDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let newsDescriptionText = UILabel()
    private let imageView = UIImageView()
    var data: RealmNews?
    let imageContainer = UIView()
    let textBackingView = UIView()
    private var previousStatusBarHidden = false
    weak var cardDelegate: CloseCardViewDelegate?
    var isFavViewController = false
    var favDictModelNews: FirebaseDictToModel?
    let frontView = UIView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let coloredLabel = UILabel()
    private let closeViewButton = UIButton()
    //MARK: — Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    //MARK: — Status Bar Appearance
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    private var shouldHideStatusBar: Bool {
        let frame = textBackingView.convert(textBackingView.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewSettings()
        populateData()
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .gray
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.addSubview(frontView)
        
        newsDescriptionText.textColor = .black
        newsDescriptionText.numberOfLines = 0
        newsDescriptionText.font = UIFont(name: "Montserrat-Thin", size: 16)
        
        
        
        let textContainer = UIView()
        textContainer.backgroundColor = .white
        textBackingView.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        textBackingView.clipsToBounds = true
        scrollView.addSubview(textBackingView)
        textBackingView.addSubview(textContainer)
        
        
        imageContainer.backgroundColor = .darkGray
        scrollView.addSubview(imageContainer)
        scrollView.addSubview(imageView)
        textContainer.addSubview(newsDescriptionText)
        
        imageContainer.snp.makeConstraints {
            make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width).multipliedBy(1.05)
        }
        
        frontView.snp.makeConstraints{
            make in
            make.top.equalTo(imageView)
            make.left.right.equalTo(imageView)
            make.bottom.equalTo(imageView)
        }
        frontView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        imageContainer.isUserInteractionEnabled = true
        
        textBackingView.snp.makeConstraints {
            make in
            make.top.equalTo(imageContainer)
            make.bottom.equalTo(view)
            make.left.right.equalTo(view)
        }
        
        scrollView.snp.makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        
        imageView.snp.makeConstraints {
            make in
            make.left.right.equalTo(imageContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            make.bottom.equalTo(imageContainer.snp.bottom)
        }
        
        textContainer.snp.makeConstraints {
            make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
        }
        
        newsDescriptionText.snp.makeConstraints {
            make in
            make.edges.equalTo(textContainer).inset(10)
        }
        
        
        closeViewButton.layer.cornerRadius = 15
        closeViewButton.backgroundColor = UIColor.clear
        let image = UIImage(named: "icons8-cancel-filled-32")?.withRenderingMode(.alwaysTemplate)
        closeViewButton.setImage(image, for: .normal)
        closeViewButton.addTarget(self, action:#selector(self.closeView), for: .touchUpInside)
        closeViewButton.clipsToBounds = true
        closeViewButton.tintColor = UIColor.white
        closeViewButton.layer.borderWidth = 2
        closeViewButton.layer.borderColor = UIColor.white.cgColor
        closeViewButton.addBlurEffect()
        self.view.addSubview(closeViewButton)
        
        closeViewButton.snp.makeConstraints {
            make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.top).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
        }
        
        frontView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
    }
    
    func populateData()
    {
        let text =  """
                    Lorem ipsum dolor sit amet, in alia adhuc aperiri nam. Movet scripta tractatos cu eum, sale commodo meliore ea eam, per commodo atomorum ea. Unum graeci iriure nec an, ea sit habeo movet electram. Id eius assum persius pro, id cum falli accusam. Has eu fierent partiendo, doming expetenda interesset cu mel, tempor possit vocent in nam. Iusto tollit ad duo, est at vidit vivendo liberavisse, vide munere nonumy sed ex.
                            
                    Quod possit expetendis id qui, consequat vituperata ad eam. Per cu elit latine vivendum. Ei sit nullam aliquam, an ferri epicuri quo. Ex vim tibique accumsan erroribus. In per libris verear adipiscing. Purto aliquid lobortis ea quo, ea utinam oportere qui.
                    """
        
        var attributedString = NSMutableAttributedString(string: "")
        let df = DateFormatter()
        let attributedStringDesc: NSMutableAttributedString
        var dateString = ""
        if (isFavViewController)
        {
            attributedString = NSMutableAttributedString(string: (favDictModelNews?.title)!)
            
            //Setting date and newstype texts if it's normal news (not favorited)
            dateString = df.convertDate((favDictModelNews?.date)!)
            coloredLabel.text = "General"
            
            //Setting description text if it's normal news (not favorited)
            if let desc = favDictModelNews?.desc {
                attributedStringDesc = NSMutableAttributedString(string: desc)
            }
            else {
                attributedStringDesc = NSMutableAttributedString(string: text + text + text)
            }
            let paragraphStyleDesc = NSMutableParagraphStyle()
            paragraphStyleDesc.lineSpacing = 4
            attributedStringDesc.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyleDesc, range:NSMakeRange(0, attributedStringDesc.length))
            
            newsDescriptionText.attributedText = attributedStringDesc
            //Setting background image if it's normal news (not favorited)
            if favDictModelNews?.imgURL != "" {
                imageView.imageFromServerURL((favDictModelNews?.imgURL)!, placeHolder: #imageLiteral(resourceName: "jon-tyson-195064-unsplash"))
            }
            else {
                imageView.image = #imageLiteral(resourceName: "jon-tyson-195064-unsplash")
            }
        }
        else
        {
            attributedString = NSMutableAttributedString(string: (data?.title)!)
            
            //Setting date and newstype texts if it's normal news (not favorited)
            dateString = df.convertDate((data?.publishedAt)!)
            coloredLabel.text = data?.newsType.capitalizingFirstLetter()
            
            //Setting description text if it's normal news (not favorited)
            if let desc = data?.descr {
                attributedStringDesc = NSMutableAttributedString(string: desc)
            }
            else {
                attributedStringDesc = NSMutableAttributedString(string: text + text + text)
            }
            let paragraphStyleDesc = NSMutableParagraphStyle()
            paragraphStyleDesc.lineSpacing = 4
            attributedStringDesc.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyleDesc, range:NSMakeRange(0, attributedStringDesc.length))
            
            newsDescriptionText.attributedText = attributedStringDesc
            //Setting background image if it's normal news (not favorited)
            if let art = data?.urlToImage {
                imageView.imageFromServerURL(art, placeHolder: nil)
            }
            else {
                imageView.image = #imageLiteral(resourceName: "jon-tyson-195064-unsplash")
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        titleLabel.attributedText = attributedString
        dateLabel.text = dateString
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    @objc func closeView()
    {
        cardDelegate?.closeCardView()
    }
    func viewSettings()
    {
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        titleLabel.setSizeFont(sizeFont: 25)
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        
        frontView.addSubview(titleLabel)
        
        dateLabel.textColor = UIColor.white
        
        let font = UIFont(name: "Monteserrat-Thin", size: 10)
        dateLabel.font = font
        
        
        let overlayLabel = UIView()
        overlayLabel.backgroundColor = UIColor.flatRed
        
        
        coloredLabel.textColor = UIColor.white
        coloredLabel.backgroundColor = UIColor.flatRed
        coloredLabel.setSizeFont(sizeFont: 18)
        coloredLabel.textAlignment = .left
        
        overlayLabel.addSubview(coloredLabel)
        
        coloredLabel.snp.makeConstraints {
            make in
            make.edges.equalTo(overlayLabel).inset(UIEdgeInsetsMake(2.0, 7.0, 2.0, 7.0))
        }
        
        frontView.addSubview(overlayLabel)
        frontView.addSubview(dateLabel)
        
        
        dateLabel.snp.makeConstraints {
            make in
            make.left.equalTo(imageContainer).offset(10)
            make.bottom.equalTo(imageContainer).offset(-10)
        }
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(imageContainer).offset(10)
            make.bottom.equalTo(dateLabel).offset(-40)
            make.right.equalTo(imageContainer).offset(-10)
        }
        overlayLabel.snp.makeConstraints {
            make in
            make.left.equalTo(imageContainer).offset(10)
            //make.bottom.equalTo(titleLabel).offset(-50)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
    }
}
extension UIButton
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        self.insertSubview(blurEffectView, at: 0)
        if let imageView = self.imageView{
            self.bringSubview(toFront: imageView)
        }
    }
}



