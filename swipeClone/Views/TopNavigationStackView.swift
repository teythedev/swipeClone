//
//  TopNavigationStackView.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageButton = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fireImageButton.contentMode = .scaleAspectFit
        heightAnchor.constraint(equalToConstant: 80).isActive = true

        settingsButton.setImage( UIImage(named: "top_left_profile")!.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage( UIImage(named:"top_right_messages")!.withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton, UIView(),fireImageButton,UIView(),messageButton].forEach { v in
            addArrangedSubview(v)
        }
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = translatesAutoresizingMaskIntoConstraints
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

}
