//
//  NewsFilterViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 05/09/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.


import UIKit
import DropDown

protocol NewsFilterDelegate {
    func finishPassing(country: String, category: String)
}
class NewsFilterViewController: UIViewController, UITextFieldDelegate {

    var delegate: NewsFilterDelegate?
    var countryLabel = UITextField()
    var sourceLabel = UITextField()
    var categoryLabel = UITextField()
    var sortedCountries = [String]()
    var tapCountryTFFlag = false
    var tapSourceTFFlag = false
    var tapCategoryTFFlag = false
    let dropDownCountry = DropDown()
    let dropDownSource = DropDown()
    let dropDownCategory = DropDown()
    let button = UIButton()
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
//    @IBAction func dismissVC(_ sender: Any) {
//        UIView.animate(withDuration: 1.0) { () -> Void in
//            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        }
//
//        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
//            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
//        }, completion: nil)
//
//        delegate?.finishPassing(country: locale(for: countryText.text!), category: categoryText.text!)
//        self.dismiss(animated: true, completion: nil)
//    }
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let categories = ["Politics","Business","Entertainment","Sports","Technology", "Science", "General", "Health"]
   

    override func viewDidLoad() {
        
        self.view.frame.origin.x = 50
        self.view.layer.cornerRadius = 50
        self.view.frame.origin.y = viewHeight / 2
        self.view.frame.size.width = viewWidth
        self.view.frame.size.height = viewHeight
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        self.countryLabel.delegate = self
        self.sourceLabel.delegate = self
        self.categoryLabel.delegate = self
        
        DispatchQueue.main.async {
            self.loadStackViewUIAndConstraints()
            
            self.dropDownCountry.selectionAction = { [unowned self] (index: Int, item: String) in
                self.countryLabel.text = item
                self.tapCountryTFFlag = false
                self.button.setTitle("FILTER", for: .normal)
            }
            self.dropDownSource.selectionAction = { [unowned self] (index: Int, item: String) in
                self.sourceLabel.text = item
                self.tapSourceTFFlag = false
                self.button.setTitle("FILTER", for: .normal)
            }
            self.dropDownCategory.selectionAction = { [unowned self] (index: Int, item: String) in
                self.categoryLabel.text = item
                self.tapCategoryTFFlag = false
                self.button.setTitle("FILTER", for: .normal)
            }
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let locale = NSLocale.current
                let unsortedCountries = NSLocale.isoCountryCodes.map { locale.localizedString(forRegionCode: $0)! }
                self.sortedCountries = unsortedCountries.sorted()
            }
        }
        self.initiateGestureRecognizers()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    private func loadStackViewUIAndConstraints()
    {
        //Create StackView subviews (labels & button)
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = "Filter News".uppercased()
        label.font = UIFont(name: "Avenir-Next", size: 30)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        
        labelsConfig("Filter by Country", label: countryLabel)
        labelsConfig("Filter by Source", label: sourceLabel)
        labelsConfig("Filter by Category", label: categoryLabel)
        
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.init(hexString: "#263238")
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font =  UIFont(name: "Avenir-Light", size: 20)
        button.titleLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(self.closeViewAndReload(_:)), for: .touchUpInside)
        
        //Creating and adding subviews into stackview
        let stackView = UIStackView()
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(button)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        
        //Constraint settings for stackview and other views inside it
        button.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        button.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5).isActive = true
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        label.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        countryLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5).isActive = true
        sourceLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        sourceLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5).isActive = true
        
        label.heightAnchor.constraint(equalTo: countryLabel.heightAnchor, multiplier: 0.1)
        label.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        countryLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
    }
    @objc func closeViewAndReload(_ sender: UIButton){
        if (!categories.contains(categoryLabel.text!))
        {
        delegate?.finishPassing(country: locale(for: countryLabel.text!), category: "")
        }
        else
        {
        delegate?.finishPassing(country: locale(for: countryLabel.text!), category: categoryLabel.text!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filler Functions
    private func labelsConfig(_ text: String, label: UITextField)
    {
        label.layer.cornerRadius = 5
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.clipsToBounds = true
        label.text = text
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.5)
    }
    private func dropDownSettings(_ dropdown: DropDown, textField: UITextField)
    {
        dropdown.anchorView = textField
        dropdown.width = textField.bounds.width
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.backgroundColor = UIColor.init(hexString: "#263238")
        dropdown.selectionBackgroundColor = UIColor.darkGray
        dropdown.dismissMode = .automatic
        dropdown.textColor = UIColor.white.withAlphaComponent(0.7)
        dropdown.textFont = (UIFont(name: "Avenir-Light", size: 15))!
        dropdown.cornerRadius = 5
        dropdown.shadowColor = UIColor.black
        dropdown.shadowRadius = 3
        dropdown.shadowOpacity = 0.5
    }
    
    private func locale(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode.lowercased()
            }
        }
        return locales.lowercased()
    }
}
extension NewsFilterViewController {
    
    func initiateGestureRecognizers()
    {
        let tapCountry = UITapGestureRecognizer(target: self, action: #selector(tapCountryTF(gestureReconizer:)))
        countryLabel.addGestureRecognizer(tapCountry)
        countryLabel.isUserInteractionEnabled = true
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(tapcategoryTF(gestureReconizer:)))
        
        categoryLabel.addGestureRecognizer(tapCategory)
        categoryLabel.isUserInteractionEnabled = true
        
        let tapSource = UITapGestureRecognizer(target: self, action: #selector(tapSourceTF(gestureReconizer:)))
        sourceLabel.addGestureRecognizer(tapSource)
        sourceLabel.isUserInteractionEnabled = true
    }
    
    // MARK: Gesture Recognizers
    
    @objc func tapcategoryTF(gestureReconizer: UITapGestureRecognizer) {
        //When user taps on Category Field, picker is shown to select categories, next subsequent tap hides the picker
        if tapCategoryTFFlag == false
        {
            dropDownSettings(dropDownCategory, textField: categoryLabel)
            
            DispatchQueue.main.async {
                self.dropDownCategory.dataSource = self.categories.sorted()
                self.dropDownCategory.show()
                self.tapCategoryTFFlag = true
            }
        }
        else
        {
            dropDownCategory.hide()
            tapCategoryTFFlag = false
        }
    }
    @objc func tapCountryTF(gestureReconizer: UITapGestureRecognizer) {
        //When user taps on Country Field, picker is shown to select country, next subsequent tap hides the picker
        if tapCountryTFFlag == false
        {
            dropDownSettings(dropDownCountry, textField: countryLabel)
            DispatchQueue.main.async {
                self.dropDownCountry.dataSource = self.sortedCountries
                self.dropDownCountry.show()
            }
            tapCountryTFFlag = true
        }
        else
        {
            dropDownCountry.hide()
            tapCountryTFFlag = false
        }
    }
    @objc func tapSourceTF(gestureReconizer: UITapGestureRecognizer) {
        
        //When user taps on Source Field, picker is shown to select source, next subsequent tap hides the picker
        if tapSourceTFFlag == false
        {
            dropDownSettings(dropDownSource, textField: sourceLabel)
            DispatchQueue.main.async {
                self.dropDownSource.dataSource = ["CNN", "ABC.com", "NPR"].sorted()
                self.dropDownSource.show()
            }
            tapSourceTFFlag = true
        }
        else
        {
            dropDownSource.hide()
            tapSourceTFFlag = false
        }
    }
    
}
