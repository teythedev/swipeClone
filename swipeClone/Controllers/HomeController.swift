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
        
        setupLayout()
        fetchCurrentUser()
        //fetchUsersFromFireStore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
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
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {return}
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        //Pagination to page through 2 user at a time
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThan: maxAge)//.order(by: "uid").start(after: [lastFetchUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { snapshot, error in
            hud.dismiss()
            if let error = error {
                print("Failed to fetch users: \(error.localizedDescription)")
                    return
            }
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
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


