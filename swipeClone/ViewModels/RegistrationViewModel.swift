//
//  RegistrationViewModel.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 29.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift



final class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
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
    
     
func checkFormValidity() {
        let isFormValid = fullName?.isEmpty  == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {return}
        self.bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully registered user: \(result?.user.uid ?? "")")
            self?.uploadImage { error in
                if let error = error {
                    completion(error)
                    return
                }
                self?.bindableIsRegistering.value = false
                
            }
        }
    }
    
    fileprivate func uploadImage(completion: @escaping (Error?) -> ()) {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
               completion(error)
                return
            }
            print("Finished uploading image to storage ")
            ref.downloadURL { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                print("Download url of our image is: \(url?.absoluteString ?? "")")
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFireStore(imageUrl: imageUrl , completion: completion)
            }
        }
    }
    
    fileprivate func saveInfoToFireStore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String: Any] = [
            "fullName" : fullName ?? "",
            "uid" : uid,
            "imageUrl1": imageUrl,
            "age": 18,
            "minSeekingAge": SettingsController.defaultMinSeekingAge,
            "maxSeekingAge": SettingsController.defaultMaxSeekingAge
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    


   
}
