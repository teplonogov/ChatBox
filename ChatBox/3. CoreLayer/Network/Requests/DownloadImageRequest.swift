//
//  DownloadImageRequest.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


class DownloadImageRequest: IRequest {
    
    var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    
}
