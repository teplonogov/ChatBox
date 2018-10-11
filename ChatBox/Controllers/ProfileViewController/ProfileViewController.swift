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
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Task 4.2
    
    /*
 
     Распечатать свойство frame у кнопки editButton в момент иниициализации контроллера не получится, т.к. его properties еще не успели инициализироваться => editButton = nil => программа упадет.
 
     */
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Frame from viewDidLoad: \(editButton.frame)")
        
        
        if let data = UserDefaults.standard.object(forKey: avatar_image) {
            let avatar = UIImage(data: data as! Data)
            avatarImageView.image = avatar
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Frame from viewDidAppear: \(editButton.frame)")
        /*
         Frame отличается от frame во время viewDidLoad, т.к. в сториборде выбран девайс iPhone SE, а симулятор – iPhone X. Дело в том, что компилятор сначала берет текущие размеры view из сториборда, а уже после перестраивает их согласно Constraints => размеры отличаются. Если же в симуляторе и в сториборде будут устройства с одинаковыми размерами дисплея, то frame не изменится.
         */
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
        print("🔵 Edit profile button was tapped ")
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureViews() {
        let cornerRadius = photoContainerView.bounds.width/2
        photoContainerView.layer.cornerRadius = cornerRadius
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
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
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
