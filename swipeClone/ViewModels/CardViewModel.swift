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
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex : Int = 0 {
        didSet {
            guard let image = UIImage(named: imageNames[imageIndex]) else { return }
            imageIndexObserver?(imageIndex,image)
        }
    }
    
    //Reactive programming
    
    var imageIndexObserver: ((Int,UIImage) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex =  max(0, imageIndex - 1)
    }
}

