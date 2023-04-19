//
//  CardView.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func  didRemoveCard(cardView: CardView)
}

final class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotosController.cardViewModel = cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            
            (0..<cardViewModel.imageUrls.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            
            setupImageIndexObserver()
            
        }
    }
    
    fileprivate let barsStackView = UIStackView()
//    fileprivate let imageView = UIImageView(image: UIImage())
        // replace it UIPageViewController
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate var imageIndex: Int = 0
    
    /// Configuration
    fileprivate let treshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
       addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    // MARK: - Fileprivate methods
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
        
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] index,imageUrl in
            if let url = URL(string: imageUrl ?? "")  {
               // self?.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"),options: .continueInBackground)
            }
            self?.barsStackView.arrangedSubviews.forEach { v in
                v.backgroundColor = self?.barDeselectedColor
            }
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
           
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ v in
                v.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            break
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > treshold
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: .curveEaseOut
        ) {
            if shouldDismissCard {
                self.transform = .identity
                self.frame = CGRect(
                    x: 600 * translationDirection,
                    y: 0,
                    width: self.frame.width,
                    height: self.frame.height
                )
            } else {
                self.transform = .identity
            }
        } completion: { _ in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
                
                // reset top card view in homecontroller
                self.delegate?.didRemoveCard(cardView: self)
            }
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        print("handling tap and cycling photos")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        }else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    
}
