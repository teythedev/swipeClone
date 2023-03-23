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

struct CardViewModel {
    // Define props that are view will display / render out
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

