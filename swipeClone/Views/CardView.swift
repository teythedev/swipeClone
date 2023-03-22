//
//  CardView.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        print(translation.x)
        
        self.transform = CGAffineTransform(translationX: <#T##CGFloat#>, y: <#T##CGFloat#>)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

}
