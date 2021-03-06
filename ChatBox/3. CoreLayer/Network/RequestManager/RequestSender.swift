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
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {

        guard let urlRequest = requestConfig.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }

        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if let unwrappedError = error {
                completionHandler(Result.error(unwrappedError.localizedDescription))
                return
            }
            guard let unwrappedData = data,
                let parsedModel: Parser.Model = requestConfig.parser.parse(data: unwrappedData) else {
                completionHandler(Result.error("received data can't be parsed"))
                return
            }
            completionHandler(Result.success(parsedModel))

        }

        task.resume()

    }

    func fetchImage(urlString: String, completionHandler: @escaping (PixabayImage?, Error?) -> Void) {

        guard let url = URL(string: urlString) else {
            print("⭕️ Error: invalid url")
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            if let unwrappedError = error {
                completionHandler(nil, unwrappedError)
                return
            }

            if let unwrappedData = data, let image = UIImage(data: unwrappedData) {
                let pixabayImage = PixabayImage(image: image, largeImageURL: nil)
                completionHandler(pixabayImage, nil)
            }
        }

        task.resume()

    }

}
