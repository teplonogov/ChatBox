//
//  PixabayImagesParser.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

struct PixabayItem: Codable {
    let webformatURL: String
    let largeImageURL: String
}

struct PixabayModel: Codable {
    let totalHits: Int
    let hits: [PixabayItem]
}

struct PixabayImage {
    let imageData: Data
    lazy var largeImageURL: String? = nil
}
