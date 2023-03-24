//
//  Extensions+CardViewModel.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 23.03.2023.
//

import UIKit

//extension CardViewModel {
//    static func make(with user: User) -> CardViewModel {
//        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
//        attributedText.append(NSMutableAttributedString(string: " \(user.age)", attributes: [
//            .font: UIFont.systemFont(ofSize: 24, weight: .regular)
//        ]))
//        attributedText.append(NSMutableAttributedString(string: " \n\(user.profession)", attributes: [
//            .font: UIFont.systemFont(ofSize: 20, weight: .regular)
//        ]))
//        
//        return CardViewModel(imageNames: user.imageNames[0], attributedString: attributedText, textAlignment: NSTextAlignment.left)
//        
//    }
//    static func make(with advertiser: Advertiser) -> CardViewModel {
//        let attributedString = NSMutableAttributedString(
//            string: advertiser.title,
//            attributes: [.font : UIFont.systemFont(
//                ofSize: 34,
//                weight: .heavy
//            )]
//        )
//        attributedString.append(NSMutableAttributedString(string: "\n\(advertiser.brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
//        
//        return CardViewModel(imageName: advertiser.posterPhotoName, attributedString: attributedString, textAlignment: NSTextAlignment.center)
//    }
//}
