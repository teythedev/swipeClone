//
//  RegistrationViewModel.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 29.03.2023.
//

import UIKit



final class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty  == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
        
        
    }

    var bindableIsFormValid = Bindable<Bool>()
}
