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
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var editMode: Bool = false

    var nameWasChanged: Bool = false
    var descriptionWasChanged: Bool = false
    var avatarWasChanged: Bool = false
    var dataWasChanged: Bool = false

    // Dependencies

    private let model: IProfileModel
    private let presentationAssembly: IPresentationAssembly

    init(model: IProfileModel, presentationAssembly: PresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // DisplayModel
    private var profileToSave: ProfileDisplayModel?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.delegate = self
        model.delegate = self

        model.fetchUserProfile()

        self.avatarButton.alpha = 0.2
        avatarButton.isHidden = true
        activityIndicator.startAnimating()

        saveButton.isEnabled = false

        switchEditMode(isDataChanged: editMode)
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

    // MARK: - Actions

    @IBAction func saveAction(_ sender: UIButton) {
        saveData()
    }

    func saveData() {

        guard dataWasChanged == true, let profile = profileToSave else {
            print("Nothing was changed or profile is nil")
            return
        }

        activityIndicator.startAnimating()

        model.saveUserProfile(profile: profile) { (error) in
            guard let unwrappedError = error else {
                self.activityIndicator.stopAnimating()
                self.dataWasChanged = false
                self.switchEditMode(isDataChanged: self.dataWasChanged)

                let completeAlert = UIAlertController(title: "Data was saved", message: nil, preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                completeAlert.addAction(continueAction)
                self.present(completeAlert, animated: true, completion: nil)
                return
            }
            self.activityIndicator.stopAnimating()
            print("Can't save data:\(unwrappedError.localizedDescription)")
            let errorAlert = UIAlertController(title: "Error!",
                                               message: "Can't save information",
                                               preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { (_) in
                self.saveData()
            })
            errorAlert.addAction(continueAction)
            errorAlert.addAction(repeatAction)
            self.present(errorAlert, animated: true, completion: nil)
        }

    }

    @IBAction func chooseAvatarTapped(_ sender: UIButton) {
        print("🔵 Choose image for profile's avatar")

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        let actionSheet = UIAlertController(title: nil, message: avatarEdit, preferredStyle: .actionSheet)

        let libraryButton = UIAlertAction(title: libraryText, style: .default) { [weak self] (_) in
            imagePicker.sourceType = .photoLibrary
            self?.present(imagePicker, animated: true, completion: nil)
        }

        let cameraButton = UIAlertAction(title: cameraText, style: .default) { [weak self] (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available in Simulator")
            }
        }
        
        let downloadButton = UIAlertAction(title: downloadText, style: .default) { [weak self] (_) in
            self?.presentImageLoaderVC()
        }

        let deleteButton = UIAlertAction(title: deleteText, style: .destructive) { [weak self] (_) in
            self?.avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
            self?.avatarWasChanged = true
            self?.dataWasChanged = true
            self?.switchEditMode(isDataChanged: (self?.dataWasChanged)!)
        }

        let cancelButton = UIAlertAction(title: cancelText, style: .cancel, handler: nil)

        actionSheet.addAction(libraryButton)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(downloadButton)

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
            }, completion: { _ in
                self.avatarButton.isHidden = true
            })
        }

    }

    @IBAction func nameFieldEditingChanged(_ sender: UITextField) {

        if sender.text != profileToSave?.name {
            profileToSave?.name = sender.text ?? "No name"
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
            saveButton.layer.borderColor = UIColor.black.cgColor
            saveButton.setTitleColor(UIColor.black, for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.layer.borderColor = UIColor.gray.cgColor
            saveButton.setTitleColor(UIColor.gray, for: .normal)
            saveButton.isEnabled = false
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
    }
    
    func presentImageLoaderVC() {
        let vc = presentationAssembly.createImageLoaderViewController()
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - Notifications

    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWiilDissapear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardDidAppear(_ notification: NSNotification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardRect = rect else {
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

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let newAvatar = info[.originalImage] as? UIImage else {
            return
        }

        avatarImageView.image = newAvatar
        profileToSave?.avatar = newAvatar
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

        if textView.text != profileToSave?.description {
            profileToSave?.description = textView.text
            self.descriptionWasChanged = true
            self.dataWasChanged = true
        } else {
            self.descriptionWasChanged = false
            self.dataWasChanged = self.nameWasChanged || self.avatarWasChanged
        }

        switchEditMode(isDataChanged: self.dataWasChanged)

    }

}

extension ProfileViewController: ProfileModelDelegate {

    func recievedUserProfile(profile: ProfileDisplayModel) {
        self.profileToSave = profile
        self.nameTextField.text = profile.name
        self.descriptionTextView.text = profile.description
        self.avatarImageView.image = profile.avatar
        self.activityIndicator.stopAnimating()
    }

}
