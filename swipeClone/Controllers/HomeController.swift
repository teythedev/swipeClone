//
//  ViewController.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 22.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        print("Notify dismissal from settings controller")
        fetchCurrentUser()
        fetchUsersFromFireStore()
    }
}
extension HomeController: LoginControllerDelegate {
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
}


final class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
        
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
        //fetchUsersFromFireStore()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registerController = RegistrationViewController()
            registerController.delegate = self
            let navController = UINavigationController(rootViewController: registerController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }

    
    // MARK: - Setup
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
       AuthService.shared.getCurrentUser(completion: { user in
           self.user = user
           self.fetchUsersFromFireStore()
        })
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .systemBackground
        let overallStackView = UIStackView(arrangedSubviews: [
            topStackView,
            cardsDeckView,
            bottomControls,
        ])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    

    fileprivate var lastFetchUser: User?
    fileprivate func fetchUsersFromFireStore() {
       // guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {return}
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        //Pagination to page through 2 user at a time
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThan: maxAge)//.order(by: "uid").start(after: [lastFetchUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { snapshot, error in
            hud.dismiss()
            if let error = error {
                print("Failed to fetch users: \(error.localizedDescription)")
                    return
            }
            
            //set next card view realationship for all card
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    @objc fileprivate func handleLike() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(
                x: 600 ,
                y: 0,
                width: self.topCardView!.frame.width,
                height: self.topCardView!.frame.height
            )
            let angle = 15 * CGFloat.pi / 180
            self.topCardView?.transform = CGAffineTransform(rotationAngle: angle)
        } completion: { (_) in
            self.topCardView?.removeFromSuperview()
            self.topCardView = self.topCardView?.nextCardView
        }
        

        
       

    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    // MARK: - Handles
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func handleMessages() {
        let vc = RegistrationViewController()
        present(vc, animated:  true)
    }
    
    @objc fileprivate func handleRefresh() {
            fetchUsersFromFireStore()
    }
    

    
   
}

extension HomeController: CardViewDelegate {
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let  userDetailsController = UserDetailsViewController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
}


