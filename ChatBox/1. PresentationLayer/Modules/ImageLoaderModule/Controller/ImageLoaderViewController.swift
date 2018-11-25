//
//  ImageLoaderViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 23/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ImageLoaderViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    weak var profileLoadDelegate: ProfileLoadImageDelegate?
    
    private var dataSource: [CellDisplayModel] = []
    private let model: IImageLoaderModel
    private let presentationAssembly: IPresentationAssembly
    
    init(model: IImageLoaderModel, presentationAssembly: PresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "ImageLoaderViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pageNumber: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageLoaderCell", bundle: nil), forCellWithReuseIdentifier: "ImageLoaderCell")
        
        let closeButtonImage = #imageLiteral(resourceName: "CloseButton")
        
        let closeButton = UIBarButtonItem.init(image: closeButtonImage,
                                               style: .done,
                                               target: self,
                                               action: #selector(closeAction))
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = closeButton
        self.title = "Pixabay Images"
        self.navigationController?.navigationBar.isTranslucent = false
        
        model.fetchSmallImages(with: pageNumber)
    }
    
    deinit {
        print("ImageLoaderViewController: DEINIT")
        model.cleanFetchedData()
    }
    
    //MARK: - Actions
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

}


extension ImageLoaderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLoaderCell", for: indexPath) as? ImageLoaderCell
        let image = dataSource[indexPath.row].smallImage
        cell?.imageView.image = image
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 3*collectionView.bounds.width/11
        let height = width
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 10, left: collectionView.bounds.width/22, bottom: 10, right: collectionView.bounds.width/22)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.width/22
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = dataSource.count - 1
        
        if indexPath.row == lastItem {
            model.fetchSmallImages(with: pageNumber)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.fetchLargeImage(from: indexPath)
    }
    
    
}


extension ImageLoaderViewController: IImageLoaderModelDelegate {
    
    func setup(dataSource: [CellDisplayModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        pageNumber += 1
    }
    
    func didRecieveLargeImage(displayModel: CellDisplayModel) {
        DispatchQueue.main.async {
            if let image = displayModel.largeImage {
                self.profileLoadDelegate?.didSelectImagePixabay(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func show(error message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
