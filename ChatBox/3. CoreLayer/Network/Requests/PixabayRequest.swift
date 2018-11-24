//
//  File.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


class PixabayRequest: IRequest {
    
    private let baseUrl: String = "https://pixabay.com/api/"
    private let apiKey: String
    private let searchString: String = "humans"
    var page: Int = 1
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private var getParameters: [String : String] {
        return ["key":apiKey,
                  "q":searchString,
               "page":"\(page)"]
    }
    
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    
}
