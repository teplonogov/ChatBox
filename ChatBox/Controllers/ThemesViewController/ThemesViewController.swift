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
    
    var themes = Themes()
    
    
    var handler: ((UIColor) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let themeData = UserDefaults.standard.object(forKey: "theme") as? Data {
            let themeColor = NSKeyedUnarchiver.unarchiveObject(with: themeData) as? UIColor
            self.view.backgroundColor = themeColor
        } else {
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
      
        let closeButtonImage = #imageLiteral(resourceName: "CloseButton")
    
        let closeButton = UIBarButtonItem.init(image: closeButtonImage, style: .done, target: self, action: #selector(closeAction))
        
        themeOneButton.layer.cornerRadius = 10
        themeTwoButton.layer.cornerRadius = 10
        themeThreeButton.layer.cornerRadius = 10
        
        self.themes.theme1 = UIColor.white
        self.themes.theme2 = UIColor.skyBlue()
        self.themes.theme3 = UIColor.nightBlue()
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = closeButton
        self.navigationController?.navigationBar.isTranslucent = false
    }
    

    //MARK: - Actions

    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func themeOneAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.themes.theme1;
            self.navigationController?.navigationBar.tintColor = UIColor.skyBlue()
            self.navigationController?.navigationBar.barStyle = .default
            self.setNavBarTheme(color: self.themes.theme1)
        }

        handler(themes.theme1)
        
    }
    
    @IBAction func themeTwoAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.themes.theme2;
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = .blackOpaque
            self.setNavBarTheme(color: self.themes.theme2)
        }
        
        handler(themes.theme2)
    }
    
    @IBAction func themeThreeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.themes.theme3;
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = .blackOpaque
            self.setNavBarTheme(color: self.themes.theme3)
        }
        
        handler(themes.theme3)
    }
    
    func setNavBarTheme(color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
    }
    
}
