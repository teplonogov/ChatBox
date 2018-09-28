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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //configureViews()

    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureViews()
    }
    

    func configureViews() {
        let cornerRadius = photoContainerView.bounds.width/2
        photoContainerView.layer.cornerRadius = cornerRadius
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: - Actions
    
    @IBAction func chooseAvatarTapped(_ sender: UIButton) {
        print("🔵 Choose image for profile's avatar")
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        print("🔵 Edit profile button was tapped ")
    }
    

}
