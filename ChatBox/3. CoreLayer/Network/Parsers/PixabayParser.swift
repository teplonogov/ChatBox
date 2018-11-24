//
//  PixabayParser.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class PixabayParser: IParser {

    typealias Model = PixabayModel
    
    func parse(data: Data) -> PixabayModel? {
        let decoder = JSONDecoder()
        let pixabayModel: PixabayModel? = try? decoder.decode(PixabayModel.self, from: data)
        return pixabayModel
    }
    
    
}
