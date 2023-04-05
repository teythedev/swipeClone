//
//  SettingsController.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 1.04.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD
import SDWebImage

final class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

final class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    fileprivate var user: User?
    
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        print("Selecte photo with button: \(button)")
        let imagePicker = CustomImagePickerController()
        imagePicker.imageButton = button
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton  = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { _ , error in
            
            if let error = error {
                hud.dismiss()
                print("Failed to upload image to storage:", error)
                return
            }
            
            print("finished uploading image")
            ref.downloadURL { url, error in
                hud.dismiss()
                if let error = error {
                    
                    print("Failed to retrieve download url:", error)
                    return
                }
                
                print("Finished getting donwload url \(url?.absoluteString ?? "")")
                
                switch imageButton {
                case self.image1Button:
                    print("1")
                    self.user?.imageUrl1 = url?.absoluteString
                case self.image2Button:
                    print("2")
                    self.user?.imageUrl2 = url?.absoluteString
                case self.image3Button:
                    print("3")
                    self.user?.imageUrl3 = url?.absoluteString
                default:
                    break
                }
            }
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            // Fetched user
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            
            self.loadUserPhotos()
            self.tableView.reloadData()
            
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground ,progress: nil) { image, _, _, _, _, _ in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        } else {return}
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground ,progress: nil) { image, _, _, _, _, _ in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        } else {return}
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground ,progress: nil) { image, _, _, _, _, _ in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        } else {return}
       
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title  = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleSave() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let documentData: [String: Any] = [
            "uid" : uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? ""
            
        ]
        let hud  = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Profiles"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(documentData) { error in
            hud.dismiss()
            if let error = error {
                print("Failed to save user settings", error)
                return
            }
            print("Finished saving info")
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    lazy var header: UIView = {
        let header = UIView()
        let padding: CGFloat = 16
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            image2Button, image3Button
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
            return headerLabel
        case 2:
            headerLabel.text = "Profession"
            return headerLabel
        case 3:
            headerLabel.text = "Age"
            return headerLabel
        default:
            headerLabel.text = "Bio"
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name ?? ""
            cell.textField.addTarget(self, action: #selector(handleNameChanged), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession ?? ""
            cell.textField.addTarget(self, action: #selector(handleProfessionChanged), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChanged), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
            
        }
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    @objc fileprivate func handleNameChanged(textField: UITextField) {
        
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChanged(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChanged(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
}

extension SettingsController {
    final class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
}

