//
//  ThemesViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 14/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet var themeOneButton: UIButton!
    @IBOutlet var themeTwoButton: UIButton!
    @IBOutlet var themeThreeButton: UIButton!

    // Dependencies

    private let model: IThemesModel
    private let presentationAssembly: IPresentationAssembly

    init(model: IThemesModel, presentationAssembly: PresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "ThemesViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var handler: ((UIColor) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        model.setTheme(forVC: self)

        let closeButtonImage = #imageLiteral(resourceName: "CloseButton")

        let closeButton = UIBarButtonItem.init(image: closeButtonImage,
                                               style: .done,
                                               target: self,
                                               action: #selector(closeAction))

        themeOneButton.layer.cornerRadius = 10
        themeTwoButton.layer.cornerRadius = 10
        themeThreeButton.layer.cornerRadius = 10

        model.themes.theme1 = UIColor.white
        model.themes.theme2 = UIColor.skyBlue()
        model.themes.theme3 = UIColor.nightBlue()

        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = closeButton
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Themes"
    }

    // MARK: - Actions

    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func themeOneAction(_ sender: UIButton) {

        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.model.themes.theme1
            self.navigationController?.navigationBar.tintColor = UIColor.skyBlue()
            self.navigationController?.navigationBar.barStyle = .default
            self.setNavBarTheme(color: self.model.themes.theme1)
        }

        handler(model.themes.theme1)

    }

    @IBAction func themeTwoAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.model.themes.theme2
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = .blackOpaque
            self.setNavBarTheme(color: self.model.themes.theme2)
        }

        handler(model.themes.theme2)
    }

    @IBAction func themeThreeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.model.themes.theme3
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = .blackOpaque
            self.setNavBarTheme(color: self.model.themes.theme3)
        }

        handler(model.themes.theme3)
    }

    func setNavBarTheme(color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
    }

}
