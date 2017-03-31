//
//  DSSlidePresentationAnimation.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 3/31/17.
//
//

import UIKit

class DSSlidePresentationAnimation: DSPresentationAnimation {

    let direction: Animation.Direction
    
    init(direction: Animation.Direction, rotation: Bool) {
        self.direction = direction
        self.rotation = rotation
    }
    
    let rotation: Bool
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? DSTransitionAnimation else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        let startingBackgroundAlpha = toViewController.backgroundView.alpha
        toViewController.backgroundView.alpha = 0
        
        let transform = getTransformPropertiesForDirection(direction: direction, toView: toView)
        let rotationAngle = self.rotationAngle != nil ? self.rotationAngle! : transform.rotationAngle
        toViewController.contentView.transform = rotation ? CGAffineTransform(rotationAngle: rotationAngle).concatenating(transform.translation) : transform.translation
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext) * 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        toViewController.backgroundView.alpha = startingBackgroundAlpha
        }, completion: nil)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        toViewController.contentView.transform = CGAffineTransform.identity
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func getTransformPropertiesForDirection(direction: Animation.Direction, toView: UIView) -> (translation: CGAffineTransform, rotationAngle: CGFloat) {
        switch direction {
        case .top:
            return (CGAffineTransform(translationX: 0, y: -toView.frame.size.height), CGFloat.pi)
        case .right:
            return (CGAffineTransform(translationX: toView.frame.size.width, y: 0), CGFloat.pi / 2)
        case .left:
            return (CGAffineTransform(translationX: -toView.frame.size.width, y: 0), CGFloat.pi / 2)
        case .bottom:
            return (CGAffineTransform(translationX: 0, y: toView.frame.size.height), CGFloat.pi / 2)
        case .topRight:
            return (CGAffineTransform(translationX: toView.frame.size.width, y: -toView.frame.size.height), -CGFloat.pi / 2)
        case .topLeft:
            return (CGAffineTransform(translationX: -toView.frame.size.width, y: -toView.frame.size.height), CGFloat.pi / 2)
        case .bottomRight:
            return (CGAffineTransform(translationX: toView.frame.size.width, y: toView.frame.size.height), CGFloat.pi / 2)
        case .bottomLeft:
            return (CGAffineTransform(translationX: -toView.frame.size.width, y: toView.frame.size.height), CGFloat.pi / 2)
        }
    }
}
