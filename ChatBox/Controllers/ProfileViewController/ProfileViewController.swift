//
//  ProfileViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 28/09/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    
    var editMode: Bool = false
    var nameWasChanged: Bool = false
    var descriptionWasChanged: Bool = false
    var avatarWasChanged: Bool = false
    var somethingWasChanged: Bool = false
    
    
    var oldName: String?
    var oldDescription: String?
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Frame from viewDidLoad: \(editButton.frame)")
        
        
        if let data = UserDefaults.standard.object(forKey: avatar_image) {
            let avatar = UIImage(data: data as! Data)
            avatarImageView.image = avatar
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
        }
        
        descriptionTextView.delegate = self
        
        self.avatarButton.alpha = 0.2
        avatarButton.isHidden = true
        
        oldName = "Alexey Teplonogov"
        oldDescription = "Love iOS Development 🔧, adore snowboarding🏂 and don't realy like study at BMSTU"
        
        nameTextField.text = oldName
        descriptionTextView.text = oldDescription
        
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        configureColorsEditMode(isDataChanged: editMode)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //print("Frame from viewDidAppear: \(editButton.frame)")

    }
    
    
    //MARK: - Actions
    
    @IBAction func chooseAvatarTapped(_ sender: UIButton) {
        print("🔵 Choose image for profile's avatar")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: avatar_edit, preferredStyle: .actionSheet)
        
        let libraryButton = UIAlertAction(title: library_text, style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraButton = UIAlertAction(title: camera_text, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available in Simulator")
            }
        }
        
        let deleteButton = UIAlertAction(title: delete_text, style: .destructive) { (action) in
            UserDefaults.standard.removeObject(forKey: avatar_image)
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
        }
        
        let cancelButton = UIAlertAction(title: cancel_text, style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryButton)
        actionSheet.addAction(cameraButton)
        
        if UserDefaults.standard.object(forKey: avatar_image) != nil {
            actionSheet.addAction(deleteButton)
        }
        
        actionSheet.addAction(cancelButton)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {

        editMode = !editMode
        let title = editMode ? "Отмена" : "Редактировать"
        editButton.setTitle(title, for: .normal)
        avatarButton.isHidden = !self.editMode

        UIView.animate(withDuration: 0.2, animations: {
            if self.editMode {
                self.nameTextField.borderStyle = .roundedRect
                self.nameTextField.isUserInteractionEnabled = true
                self.descriptionTextView.isEditable = true
                self.descriptionTextView.layer.borderWidth = 1
                self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
                self.avatarButton.alpha = 1
            } else {
                self.nameTextField.borderStyle = .none
                self.nameTextField.isUserInteractionEnabled = false
                self.descriptionTextView.isEditable = false
                self.descriptionTextView.layer.borderWidth = 0
                self.avatarButton.alpha = 0.2
            }
        })
        
    }
    
    @IBAction func nameFieldEditingChanged(_ sender: UITextField) {
        
        if sender.text != oldName {
            nameWasChanged = true
            somethingWasChanged = true
        } else {
            nameWasChanged = false
            somethingWasChanged = descriptionWasChanged
        }
        
        configureColorsEditMode(isDataChanged: somethingWasChanged)
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureColorsEditMode(isDataChanged: Bool) {
        
        if isDataChanged {
            operationButton.layer.borderColor = UIColor.black.cgColor
            operationButton.setTitleColor(UIColor.black, for: .normal)
            gcdButton.layer.borderColor = UIColor.black.cgColor
            gcdButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            operationButton.layer.borderColor = UIColor.gray.cgColor
            operationButton.setTitleColor(UIColor.gray, for: .normal)
            gcdButton.layer.borderColor = UIColor.gray.cgColor
            gcdButton.setTitleColor(UIColor.gray, for: .normal)
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
        
        gcdButton.layer.cornerRadius = 15
        gcdButton.layer.borderWidth = 1
        
        operationButton.layer.cornerRadius = 15
        operationButton.layer.borderWidth = 1
        
    }
    
    
    
    // png периодически переворчаиваются из-за rotation flag, правим это тут
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
    

}



// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let correctedImg = rotateImage(image: image)
        
        var imageData: Data?
        
        if picker.sourceType == .camera {
            imageData = correctedImg.jpegData(compressionQuality: 1.0)
        } else {
            imageData = correctedImg.pngData()
        }

        UserDefaults.standard.set(imageData, forKey: avatar_image)
        avatarImageView.image = correctedImg
        avatarWasChanged = true
        somethingWasChanged = true
        picker.dismiss(animated: true, completion: nil)
        configureColorsEditMode(isDataChanged: somethingWasChanged)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != oldDescription {
            descriptionWasChanged = true
            somethingWasChanged = true
        } else {
            descriptionWasChanged = false
            somethingWasChanged = nameWasChanged
        }
        
        configureColorsEditMode(isDataChanged: somethingWasChanged)
        
    }
    
}
