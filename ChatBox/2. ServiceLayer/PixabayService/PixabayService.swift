//
//  PixabayService.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IPixabayService {
    var fethedPixabayImages: [PixabayImage] { get set }
    func loadPixabayObjects(with page: Int, completionHandler: @escaping ([PixabayImage]?, String?) -> Void)
    func loadImagesObject(from pixabayImage:PixabayImage?, pixabayItem: PixabayItem?, completionHandler: @escaping (PixabayImage?, Error?) -> Void)
}

class PixabayService: IPixabayService {
    
    var fethedPixabayImages: [PixabayImage] = []
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadPixabayObjects(with page: Int, completionHandler: @escaping ([PixabayImage]?, String?) -> Void) {
    
        let requestConfig = RequestsFactory.pixabayObjectsConfig(page: page)
        
        requestSender.send(requestConfig: requestConfig) { (result) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let pixabayModel):
                
                for i in 0..<pixabayModel.hits.count {
                    let item = pixabayModel.hits[i]
                    self.loadImagesObject(from: nil, pixabayItem: item, completionHandler: { (pixabayImage, error) in


                        if let unwrappedError = error {
                            print("ERROR: \(unwrappedError.localizedDescription)")
                            return
                        }

                        if let unwrappedPixabay = pixabayImage {
                            let pixabay = PixabayImage.init(image: unwrappedPixabay.image, largeImageURL: item.largeImageURL)
                            self.fethedPixabayImages.append(pixabay)
                        }

                        if i == pixabayModel.hits.count - 1 {
                            completionHandler(self.fethedPixabayImages, nil)
                        }


                    })

                }

            }
        }
        
        
    }
    
    
    func loadImagesObject(from pixabayImage:PixabayImage? = nil, pixabayItem: PixabayItem?, completionHandler: @escaping (PixabayImage?, Error?) -> Void) {
        
        if let pixabay = pixabayImage {
            guard let largeURL = pixabay.largeImageURL else {
                print("Large URL is nil")
                return
            }
            
            requestSender.fetchImage(urlString: largeURL) { (updatedPixabayImage, error) in
                if let unwrappedError = error {
                    completionHandler(nil, unwrappedError)
                    return
                }
                
                if let unwrappedPixabay = updatedPixabayImage {
                    completionHandler(unwrappedPixabay, nil)
                }
            }
            return
        }
        
        
        guard let smallURL = pixabayItem?.previewURL else {
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
