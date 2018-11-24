//
//  PixabayService.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IPixabayService {
    var fethedPixabayImages: [PixabayImage]? {get}
    func loadPixabayObjects(completionHandler: @escaping ([PixabayImage]?, String?) -> Void)
    func loadImagesObject(from pixabayImage:PixabayImage?, pixabayItem: PixabayItem?, completionHandler: @escaping (PixabayImage?, Error?) -> Void)
}

class PixabayService: IPixabayService {
    
    var fethedPixabayImages: [PixabayImage]?
    
    let requestSender: RequestSender
    
    init(requestSender: RequestSender) {
        self.requestSender = requestSender
    }
    
    func loadPixabayObjects(completionHandler: @escaping ([PixabayImage]?, String?) -> Void) {
    
        let requestConfig = RequestsFactory.pixabayObjectsConfig()
        
        requestSender.send(requestConfig: requestConfig) { (result) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let pixabayModel):
         
                for item in pixabayModel.hits {
                    self.loadImagesObject(from: nil, pixabayItem: item, completionHandler: { (pixabayImage, error) in
                        
                        
                        if let unwrappedError = error {
                            print("ERROR: \(unwrappedError.localizedDescription)")
                            return
                        }
                        
                        if var unwrappedPixabay = pixabayImage {
                            unwrappedPixabay.largeImageURL = item.largeImageURL
                            self.fethedPixabayImages?.append(unwrappedPixabay)
                        }
                        
                        completionHandler(self.fethedPixabayImages, nil)
                        
                    })
                }
                //completionHandler(pixabayModel, nil)
            }
        }
        
        
    }
    
    
    func loadImagesObject(from pixabayImage:PixabayImage? = nil, pixabayItem: PixabayItem?, completionHandler: @escaping (PixabayImage?, Error?) -> Void) {
        
        
        
        
        guard let smallURL = pixabayItem?.webformatURL else {
            print("Small URL is nil")
            return
        }
        
        requestSender.fetchImage(urlString: smallURL) { (pixabayImage, error) in
            
            if let unwrappedError = error {
                completionHandler(nil, unwrappedError)
                return
            }
            
            if let unwrappedPixabay = pixabayImage {
                completionHandler(unwrappedPixabay, nil)
            }
            
        }
    }
    
    
}
