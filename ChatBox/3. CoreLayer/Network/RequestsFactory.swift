//
//  RequestsFactory.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    static func pixabayObjectsConfig() -> RequestConfig<PixabayParser> {
        let request = PixabayRequest.init(apiKey: keyPixabay)
        let parser = PixabayParser()
        let config = RequestConfig<PixabayParser>.init(request: request, parser: parser)
        return config
    }
    
    
    
}
