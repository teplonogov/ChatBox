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
    var largeImage: UIImage?
}


protocol IImageLoaderModel {
    var delegate: IImageLoaderModelDelegate? { get set }
    func fetchSmallImages(with page: Int)
    func fetchLargeImage(from indexPath:IndexPath)
    func cleanFetchedData()
}


protocol IImageLoaderModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
    func didRecieveLargeImage(displayModel: CellDisplayModel)
    func show(error message: String)
}

class ImageLoaderModel: IImageLoaderModel {
    
    weak var delegate: IImageLoaderModelDelegate?
    var pixabayService: IPixabayService
    var pixabayObjects: [PixabayImage] = []
    var displayModelDataSource: [CellDisplayModel] = []
    
    init(pixabayService: IPixabayService) {
        self.pixabayService = pixabayService
    }
    
    func fetchSmallImages(with page: Int) {
        pixabayService.loadPixabayObjects(with: page) { (pixabayImageArray, errorMessage) in
            
            if let error = errorMessage {
                self.delegate?.show(error: error)
                return
            }
            
            guard let pixabayArray = pixabayImageArray else {
                self.delegate?.show(error: "pixabay array is nil")
                return
            }
            
            self.displayModelDataSource.removeAll()
            
            for item in pixabayArray {
                let displayModel = CellDisplayModel(smallImage: item.image, largeImage: nil)
                
                self.displayModelDataSource.append(displayModel)
            }
            
            self.pixabayObjects = pixabayArray
            self.delegate?.setup(dataSource: self.displayModelDataSource)
            
        }
    }
    
    func fetchLargeImage(from indexPath:IndexPath) {
        let pixabayImage = pixabayObjects[indexPath.row]
        pixabayService.loadImagesObject(from: pixabayImage, pixabayItem: nil) { (updatedPixabayImage, error) in
            
            if let unwrappedError = error {
                self.delegate?.show(error: unwrappedError.localizedDescription)
                return
            }
        
            guard let updatedPixabay = updatedPixabayImage else {
                print("Large image seems to be nil")
                return
            }
            
            let displayModel = CellDisplayModel(smallImage: nil, largeImage: updatedPixabay.image)
            
            self.delegate?.didRecieveLargeImage(displayModel: displayModel)
        
        }
    }
    
    func cleanFetchedData() {
        pixabayService.fethedPixabayImages.removeAll()
    }
    
    
}
