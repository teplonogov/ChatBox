//
//  ProfileViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 28/09/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit
//import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    //@IBOutlet var operationButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let storageManager = CoreDataManager()
    let gcdLoadManager = GCDDataManager()
    var saveManager: GetSaveProfileProtocol!
    var profile: Profile!
    //var userProfile: UserProfile?
    //var newUserProfile: UserProfile?
    
    var editMode: Bool = false
    
    var nameWasChanged: Bool = false
    var descriptionWasChanged: Bool = false
    var avatarWasChanged: Bool = false
    var dataWasChanged: Bool = false


    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        self.avatarButton.alpha = 0.2
        avatarButton.isHidden = true
        activityIndicator.startAnimating()
        
        saveButton.isEnabled = false
        //operationButton.isEnabled = false
        
        switchEditMode(isDataChanged: editMode)
        
//        gcdLoadManager.getProfile { (userProfile) in
//            self.nameTextField.text = userProfile.name
//            self.descriptionTextView.text = userProfile.description
//            self.avatarImageView.image = userProfile.avatar
//            self.userProfile = userProfile
//            self.activityIndicator.stopAnimating()
//        }
        
        storageManager.loadProfile { (userPorfile) in
            guard let profile = userPorfile else {
                return
            }
            self.profile = profile
            self.nameTextField.text = profile.name
            self.descriptionTextView.text = profile.descriptionProfile
            let avatar = UIImage(data: profile.avatarImage!)
            self.avatarImageView.image = avatar
            self.activityIndicator.stopAnimating()
        }
        
        
        registerNotifications()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //print("Frame from viewDidAppear: \(editButton.frame)")

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func saveAction(_ sender: UIButton) {
        //saveManager = GCDDataManager()
        saveData()
    }
    
    
//    @IBAction func saveOperationAction(_ sender: Any) {
//        saveManager = OperationDataManager()
//        saveData()
//    }
    
    func saveData() {
        
        guard self.dataWasChanged == true else {
            print("Nothing was changed")
            return
        }
        
        activityIndicator.startAnimating()
        
        let newName = nameTextField.text ?? "No name"
        let newDescription = descriptionTextView.text ?? ""
        
        
        profile.name = newName
        profile.descriptionProfile = newDescription
        
        if avatarWasChanged {
            let imageData = avatarImageView.image?.jpegData(compressionQuality: 1.0)
            profile.avatarImage = imageData
        }
        
        
        storageManager.saveProfile { (error) in
            if let unwrappedError = error {
                print("Can't save data:\(unwrappedError.localizedDescription)")
                let errorAlert = UIAlertController(title: "Error!", message: "Can't save information", preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { (action) in
                    self.saveData()
                })
                errorAlert.addAction(continueAction)
                errorAlert.addAction(repeatAction)
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                self.dataWasChanged = false
                self.switchEditMode(isDataChanged: self.dataWasChanged)
                
                let completeAlert = UIAlertController(title: "Data was saved", message: nil, preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                completeAlert.addAction(continueAction)
                self.present(completeAlert, animated: true, completion: nil)
            }
            
            self.activityIndicator.stopAnimating()
            
        }
        
//        saveManager.saveProfile(profile: newUserProfile!) { error in
//
//                if let unwrappedError = error {
//                    print("Can't save data:\(unwrappedError.localizedDescription)")
//                    let errorAlert = UIAlertController(title: "Error!", message: "Can't save information", preferredStyle: .alert)
//                    let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { (action) in
//                        self.saveData()
//                    })
//                    errorAlert.addAction(continueAction)
//                    errorAlert.addAction(repeatAction)
//                    self.present(errorAlert, animated: true, completion: nil)
//
//                } else {
//                    self.newUserProfile?.dataWasChanged = false
//                    self.switchEditMode(isDataChanged: self.newUserProfile?.dataWasChanged ?? false)
//
//                    let completeAlert = UIAlertController(title: "Data was saved", message: nil, preferredStyle: .alert)
//                    let continueAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                    completeAlert.addAction(continueAction)
//                    self.present(completeAlert, animated: true, completion: nil)
//                }
//
//                self.activityIndicator.stopAnimating()
//        }

    }
    
    
    @IBAction func chooseAvatarTapped(_ sender: UIButton) {
        print("🔵 Choose image for profile's avatar")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: avatar_edit, preferredStyle: .actionSheet)
        
        let libraryButton = UIAlertAction(title: library_text, style: .default) { [weak self] (action) in
            imagePicker.sourceType = .photoLibrary
            self?.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraButton = UIAlertAction(title: camera_text, style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available in Simulator")
            }
        }
        
        let deleteButton = UIAlertAction(title: delete_text, style: .destructive) { [weak self] (action) in
            self?.avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
            self?.avatarWasChanged = true
            self?.dataWasChanged = true
            self?.switchEditMode(isDataChanged: (self?.dataWasChanged)!)
        }
        
        let cancelButton = UIAlertAction(title: cancel_text, style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryButton)
        actionSheet.addAction(cameraButton)
        
        let placeholderImage = #imageLiteral(resourceName: "placeholder-user")
        if !(avatarImageView.image?.isEqual(placeholderImage))! {
            actionSheet.addAction(deleteButton)
        }
        
        actionSheet.addAction(cancelButton)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {

        editMode = !editMode
        let title = editMode ? "Ok" : "Редактировать"
        editButton.setTitle(title, for: .normal)

        if editMode {
            //newUserProfile = UserProfile()
            self.nameTextField.isUserInteractionEnabled = true
            self.descriptionTextView.isEditable = true
            avatarButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.nameTextField.borderStyle = .roundedRect
                self.descriptionTextView.layer.borderWidth = 1
                self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
                self.avatarButton.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.nameTextField.borderStyle = .none
                self.nameTextField.isUserInteractionEnabled = false
                self.descriptionTextView.isEditable = false
                self.descriptionTextView.layer.borderWidth = 0
                self.avatarButton.alpha = 0.1
            }) { (finished) in
                self.avatarButton.isHidden = true
            }
        }

        
    }
    
    @IBAction func nameFieldEditingChanged(_ sender: UITextField) {
        
        if sender.text != profile.name {
            self.nameWasChanged = true
            self.dataWasChanged = true
        } else {
            self.nameWasChanged = false
            self.dataWasChanged = self.descriptionWasChanged || self.avatarWasChanged
        }
        
        switchEditMode(isDataChanged: self.dataWasChanged)
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func switchEditMode(isDataChanged: Bool) {
        
        if isDataChanged {
            //operationButton.layer.borderColor = UIColor.black.cgColor
            //operationButton.setTitleColor(UIColor.black, for: .normal)
            saveButton.layer.borderColor = UIColor.black.cgColor
            saveButton.setTitleColor(UIColor.black, for: .normal)
            saveButton.isEnabled = true
            //operationButton.isEnabled = true
        } else {
            //operationButton.layer.borderColor = UIColor.gray.cgColor
            //operationButton.setTitleColor(UIColor.gray, for: .normal)
            saveButton.layer.borderColor = UIColor.gray.cgColor
            saveButton.setTitleColor(UIColor.gray, for: .normal)
            saveButton.isEnabled = false
            //operationButton.isEnabled = false
        }
        
    }
    
    func configureViews() {

        let cornerRadius = avatarButton.bounds.width/2
        avatarButton.layer.cornerRadius = cornerRadius

        avatarButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        
        descriptionTextView.layer.cornerRadius = 10
        
        saveButton.layer.cornerRadius = 15
        saveButton.layer.borderWidth = 1
        
        //operationButton.layer.cornerRadius = 15
        //operationButton.layer.borderWidth = 1
        
    }
    
    
    //MARK: - Notifications
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidAppear(_ notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = -keyboardRect.height
    }
    
    
    @objc func keyboardWiilDissapear() {
        view.frame.origin.y = 0
    }
    

}



// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let newAvatar = info[.originalImage] as? UIImage else {
            return
        }

        avatarImageView.image = newAvatar
        self.avatarWasChanged = true
        self.dataWasChanged = true
        picker.dismiss(animated: true, completion: nil)
        switchEditMode(isDataChanged: self.dataWasChanged)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != profile.descriptionProfile {
            self.descriptionWasChanged = true
            self.dataWasChanged = true
        } else {
            self.descriptionWasChanged = false
            self.dataWasChanged = self.nameWasChanged || self.avatarWasChanged
        }
        
        switchEditMode(isDataChanged: self.dataWasChanged)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing ")
    }
    
}
