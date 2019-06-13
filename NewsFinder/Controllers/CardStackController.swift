//
//  CardStackController.swift
//  NewsFinder
//
//  Created by Cognizant Technology Solutions # 2 on 27/08/18.
//  Copyright © 2018 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import expanding_collection

class CardStackController: ExpandingViewController {
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate let items: [ItemInfo] = [("item0", "Boston"), ("item1", "New York"), ("item2", "San Francisco"), ("item3", "Washington")]
    
    @IBOutlet var pageLabel: UILabel!

    
        override func viewDidLoad() {
            itemSize = CGSize(width: 256, height: 460)
            super.viewDidLoad()
            
//            registerCell()
//            fillCellIsOpenArray()
//            addGesture(to: collectionView!)
//            configureNavBar()
        }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stackCell", for: indexPath)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension CardStackController {
//    fileprivate func registerCell() {
//
//        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
//        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
//    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
    
    fileprivate func getViewController() -> NewsPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController = storyboard.instantiateViewController(withIdentifier: "newsController") as! NewsPageViewController
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(CardStackController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(CardStackController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? StackCardCellCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}
