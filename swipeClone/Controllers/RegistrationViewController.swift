//
//  RegistrationViewController.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 24.03.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FirebaseStorage

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
class RegistrationViewController: UIViewController {
    
    //ui components
    
    let selectPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    lazy var selectPhotoButtonWidthAnchor =
    selectPhotoButton.widthAnchor.constraint(equalToConstant:275)
    
    lazy var selectPhotoButtonHeightAnchor =
    selectPhotoButton.heightAnchor.constraint(equalToConstant:275)
    
    let fullNameTextField : CustomTextField = {
        let tf  = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    let emailTextField : CustomTextField = {
        let tf  = CustomTextField(padding: 24, height:  50)
        tf.placeholder = "Enter email"
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    let passwordTextField : CustomTextField = {
        let tf  = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter password"
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        //        tf.isSecureTextEntry = true
        return tf
    }()
    
    @objc fileprivate func handleTextChanged(textfield: UITextField) {
        if textfield == fullNameTextField {
            registrationViewModel.fullName = fullNameTextField.text
        }else if textfield == emailTextField {
            registrationViewModel.email = emailTextField.text
        }else {
            registrationViewModel.password = passwordTextField.text
        }
    }
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = .lightGray
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        selectPhotoButtonHeightAnchor.isActive = true
        
        setupRegistrationViewModelObserver()
    }
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [weak self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self?.registerButton.isEnabled = isFormValid
            if isFormValid {
                self?.registerButton.setTitleColor(.white, for: .normal)
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
            } else {
                self?.registerButton.backgroundColor = .lightGray
            }
        }
        registrationViewModel.bindableImage.bind {[weak self] image in
            self?.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            if isRegistering ?? false {
                self?.registeringHUD.textLabel.text = "Register"
                self?.registeringHUD.show(in: self?.view ?? UIView())
            } else {
                self?.registeringHUD.dismiss()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Private
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut){ [weak self] in
            self?.view.transform = .identity
        }
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut){ [weak self] in
            self?.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        
        // find the gap between register button and bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    fileprivate lazy var overallStackView = UIStackView(
        arrangedSubviews: [
            selectPhotoButton,
            verticalStackView
        ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
            //overallStackView.distribution = .fill
            //verticalStackView.distribution = .fillEqually
            selectPhotoButtonHeightAnchor.isActive = false
            selectPhotoButtonWidthAnchor.isActive = true
        } else {
            overallStackView.axis = .vertical
            // verticalStackView.distribution = .fillEqually
            selectPhotoButtonWidthAnchor.isActive = false
            selectPhotoButtonHeightAnchor.isActive = true
        }
    }
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()

    @objc fileprivate func handleGoToLogin() {
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        
        //overallStackView.distribution = .fill
        
        overallStackView.spacing = 8
        
        overallStackView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    let gradientLayer = CAGradientLayer()
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.9807356, green: 0.3706865907, blue: 0.365704298, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8924007416, green: 0.117617093, blue: 0.4611734152, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations  = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        registrationViewModel.performRegistration { [weak self] error in
            if let error = error {
                self?.showHUDWithError(error: error)
                return
            }
            print("Finished registering our user")
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4.0)
    }
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
}




