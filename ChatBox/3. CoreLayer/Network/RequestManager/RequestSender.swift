//
//  RequestSender.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {

    let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : IParser {
        
        guard let urlRequest = requestConfig.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let unwrappedError = error {
                completionHandler(Result.error(unwrappedError.localizedDescription))
                return
            }
            guard let unwrappedData = data, let parsedModel: Parser.Model = requestConfig.parser.parse(data: unwrappedData) else {
                completionHandler(Result.error("received data can't be parsed"))
                return
            }
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    
    }
    
    
    
    func fetchImage(urlString: String, completionHandler: @escaping (PixabayImage?, Error?) -> Void) {

        let request = DownloadImageRequest(urlString: urlString)
        
        guard let imageRequest = request.urlRequest else {
            print("⭕️ Error: invalid url")
            return
        }

        session.dataTask(with: imageRequest) { (data, response, error) in
            if let unwrappedError = error {
                completionHandler(nil, unwrappedError)
                return
            }
            
            if let unwrappedData = data {
                let pixabayImage = PixabayImage(imageData: unwrappedData, largeImageURL: nil)
                completionHandler(pixabayImage, nil)
            }
        }
        
    }
    

    
    
}
