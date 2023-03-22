//
//  HomeBottomControlsStackView.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let buttonImage = [
            #imageLiteral(resourceName: "refresh_circle"),
            #imageLiteral(resourceName: "dismiss_circle"),
            #imageLiteral(resourceName: "super_like_circle"),
            #imageLiteral(resourceName: "like_circle"),
            #imageLiteral(resourceName: "boost_circle"),
        ].map { img -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        buttonImage.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
