//
//  User.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 23.03.2023.
//

import UIKit

struct User: ProducesCardViewModel {
    /// Defining props for model layer
    let name: String
    let profession: String
    let age: Int
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSMutableAttributedString(string: " \(age)", attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .regular)
        ]))
        attributedText.append(NSMutableAttributedString(string: " \n\(profession)", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .regular)
        ]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left)
    }
}
