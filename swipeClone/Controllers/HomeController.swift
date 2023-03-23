//
//  ViewController.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
        
    let cardViewModels: [CardViewModel] = {
        let producers: [ProducesCardViewModel] = [
            User(name: "Kelly", profession: "Music DJ", age: 23, imageName: "lady5c"),
            User(name: "Jane", profession: "Teacher", age: 18, imageName: "lady4c"),
            Advertiser(title: "Slide out Menu", brandName: "Let's Build That App", posterPhotoName: "slide_out_menu_poster"),
        ]
        let viewModels =  producers.map { $0.toCardViewModel()}
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    // MARK: - Fileprivate
    
    fileprivate func setupDummyCards() {
        (cardViewModels).forEach { cardViewModel in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [
            topStackView,
            cardsDeckView,
            buttonsStackView,
        ])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    
    
    
    
}

