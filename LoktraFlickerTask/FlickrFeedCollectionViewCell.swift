//
//  FlickrFeedCollectionViewCell.swift
//  LoktraFlickerTask
//
//  Created by Tuhin Samui on 10/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class FlickrFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrMainFeedImageSuperView: UIView!
    @IBOutlet weak var flickrMainFeedImageView: UIImageView!
    @IBOutlet weak var flickrMainFeedImageDetailsSuperView: UIView!
    @IBOutlet weak var flickrMainFeedImageDetailsLbl: UILabel!
    
    lazy var cellAlreadyFlipped: Bool = false
    
    
    func flipViewWithAnimation(_ firstView: UIView, secondView: UIView, flipForward: Bool, flipDuration: TimeInterval){
        switch flipForward {
        case true:
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: firstView, duration: flipDuration, options: transitionOptions, animations: {
                firstView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: secondView, duration: flipDuration, options: transitionOptions, animations: {
                secondView.isHidden = false
            }, completion: nil)
            
        case false:
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: secondView, duration: flipDuration, options: transitionOptions, animations: {
                secondView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: firstView, duration: flipDuration, options: transitionOptions, animations: {
                firstView.isHidden = false
            }, completion: nil)
        }
    }
    
    
}
