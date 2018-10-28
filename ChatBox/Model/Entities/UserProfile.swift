//
//  File.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 21/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class UserProfile {
    var name: String = "No name"
    var description: String = ""
    var avatar: UIImage?
    
    var nameWasChanged: Bool = false
    var descriptionWasChanged: Bool = false
    var avatarWasChanged: Bool = false
    var dataWasChanged: Bool = false
}
