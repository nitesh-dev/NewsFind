//
//  FlipAnimationController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 11/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit
class FlipAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    private let originFrame: CGRect
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
         let toVC = transitionContext.viewController(forKey: .to),
         let snapShot = toVC.view.snapshotView(afterScreenUpdates: true)
        else
        {
            return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        snapShot.frame = originFrame
        snapShot.layer.cornerRadius = 10.0
        snapShot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapShot)
        toVC.view.isHidden = true
        
        //AnimationHelper.perspectiveTransform(for: containerView)
        //snapShot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3)
            {
                //fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/9)
            {
                //snapShot.layer.transform = AnimationHelper.yRotation(0.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 4/9, relativeDuration: 5/9)
            {
                snapShot.frame = finalFrame
                snapShot.layer.cornerRadius = 0
            }
            
        }, completion: { _ in
               toVC.view.isHidden = false
            snapShot.removeFromSuperview()
            fromVC.view.layer.transform = CATransform3DIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        )
        
    }
    
    
}
