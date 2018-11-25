//
//  RequestsFactory.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    //static var page = 1
    
    static func pixabayObjectsConfig(page: Int) -> RequestConfig<PixabayParser> {
        let request = PixabayRequest.init(page: page, apiKey: keyPixabay)
        let parser = PixabayParser()
        let config = RequestConfig<PixabayParser>.init(request: request, parser: parser)
        //page += 1
        return config
    }
    
    
    
}
