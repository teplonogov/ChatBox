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

    
    
//    private let model: IThemesModel
    private let presentationAssembly: IPresentationAssembly
    
    init(presentationAssembly: PresentationAssembly) {
        //self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "ImageLoaderViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
    }
    
    //MARK: - Actions
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }


}


extension ImageLoaderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLoaderCell", for: indexPath)
        
        return cell
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
    
    
}
