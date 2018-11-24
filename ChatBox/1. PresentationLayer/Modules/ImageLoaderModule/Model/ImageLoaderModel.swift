//
//  ImageLoaderModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


struct CellDisplayModel {
    let smallImage: UIImage?
//    let smallImageData: Data
    var largeImageData: Data?
}


protocol IImageLoaderModel {
    var delegate: IImageLoaderModelDelegate? { get set }
    func fetchSmallImages()
    func fetchLargeImage()
}


protocol IImageLoaderModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
    func show(error message: String)
}

class ImageLoaderModel: IImageLoaderModel {
    
    weak var delegate: IImageLoaderModelDelegate?
    
    let pixabayService: IPixabayService
    
    var displayModelDataSource: [CellDisplayModel] = []
    
    init(pixabayService: IPixabayService) {
        self.pixabayService = pixabayService
    }
    
    func fetchSmallImages() {
        pixabayService.loadPixabayObjects { (pixabayImageArray, errorMessage) in
            
            if let error = errorMessage {
                self.delegate?.show(error: error)
                return
            }
            
            guard let pixabayArray = pixabayImageArray else {
                self.delegate?.show(error: "pixabay array is nil")
                return
            }
            
//            var displayModelDataSource =  [CellDisplayModel]()
            for item in pixabayArray {
                let displayModel = CellDisplayModel(smallImage: item.smallImage, largeImageData: nil)
                self.displayModelDataSource.append(displayModel)
            }
            
            self.delegate?.setup(dataSource: self.displayModelDataSource)
            
        }
    }
    
    func fetchLargeImage() {
        
    }
    
    
}
