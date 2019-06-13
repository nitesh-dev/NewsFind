//
//  FlipDismissAnimationController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 11/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    private let destinationFrame: CGRect
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
          let toVC = transitionContext.viewController(forKey: .to),
        let snapShot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        snapShot.layer.cornerRadius = 10
        snapShot.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapShot)
        fromVC.view.isHidden = true
        
        //AnimationHelper.perspectiveTransform(for: containerView)
        //toVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3 )
            {
                snapShot.frame = self.destinationFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3 )
            {
                //snapShot.layer.transform = AnimationHelper.yRotation(.pi / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3 )
            {
                //toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
            }
        }, completion: { _ in
            fromVC.view.isHidden = false
            snapShot.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    init(destinationFrame: CGRect)
    {
        self.destinationFrame = destinationFrame
    }
    
}
