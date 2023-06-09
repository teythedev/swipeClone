//
//  CardViewModel.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 23.03.2023.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

/// View model is supposed represent the state of our view
class CardViewModel {
    // Define props that are view will display / render out
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex : Int = 0 {
        didSet {
//            guard let image = UIImage(named: imageNames[imageIndex]) else { return }
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex,imageUrl)
        }
    }
    
    //Reactive programming
    
    var imageIndexObserver: ((Int,String?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex =  max(0, imageIndex - 1)
    }
}

