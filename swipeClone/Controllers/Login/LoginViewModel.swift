//
//  LoginViewModel.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 8.04.2023.
//

import Foundation
import FirebaseAuth
final class LoginViewModel {
    
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    
    var email: String? {
        didSet {checkFormValidity()}
    }
    
    var password: String? {
        didSet{
            checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()){
        guard let email = email, let password = password else {return}
        
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(error)
        }
    }
    
}
