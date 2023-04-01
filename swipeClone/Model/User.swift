//
//  User.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 23.03.2023.
//

import UIKit

struct User: ProducesCardViewModel {
    /// Defining props for model layer
    var name: String?
    var profession: String?
    var age: Int?
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        self.profession = dictionary["profession"] as? String
        self.age = dictionary["age"] as? Int
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ?  "\(age!)" : "N\\A"

        attributedText.append(NSMutableAttributedString(string: " \(ageString)", attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .regular)
         ]))
        
        let professionString = profession != nil ? profession! : "Not available"
        attributedText.append(NSMutableAttributedString(string: " \n\(professionString)", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .regular)
        ]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
