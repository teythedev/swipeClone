//
//  ViewController.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit
import FirebaseFirestore


class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
        
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFireStore()
    }
    
    // MARK: - Fileprivate
    
    fileprivate func fetchUsersFromFireStore() {
        let query = Firestore.firestore().collection("users")
        //let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Chris")
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Failed to fetch users: \(error.localizedDescription)")
                    return
            }
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupFirestoreUserCards()
            
        }
    }
    
    
    @objc func handleSettings() {
        print("Show registration page")
        present(RegistrationViewController(), animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        (cardViewModels).forEach { cardViewModel in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .systemBackground
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

