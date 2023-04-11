//
//  AuthService.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 8.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    static let shared =  AuthService()
    
    private init () {
        
    }
    
    func getCurrentUser(completion: @escaping (User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            // Fetched user
            guard let dictionary = snapshot?.data() else {return}
            completion(User(dictionary: dictionary))
        }
       
    }
}
