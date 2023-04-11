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
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        self.profession = dictionary["profession"] as? String
        self.age = dictionary["age"] as? Int
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
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
        
        var imageURls = [String]()
        if let url = imageUrl1 {
            imageURls.append(url)
        }
        if let url = imageUrl2 {
            imageURls.append(url)
        }
        if let url = imageUrl3 {
            imageURls.append(url)
        }
        
        return CardViewModel(imageNames: imageURls, attributedString: attributedText, textAlignment: .left)
    }
}
