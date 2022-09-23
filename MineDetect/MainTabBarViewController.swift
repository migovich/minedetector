//
//  MainTabBarViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        setupViewControllers()
        configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
     
    // MARK: Functions
    private func setupViewControllers() {
        let mapVC = UIStoryboard(name: MapViewController.className, bundle: nil).instantiateViewController(identifier: MapViewController.className)
        let photoVC = UIStoryboard(name: PhotoViewController.className, bundle: nil).instantiateViewController(identifier: PhotoViewController.className)
        let settingsVC = UIStoryboard(name: SettingsViewController.className, bundle: nil).instantiateViewController(identifier: SettingsViewController.className)
        
        let mapItem = UITabBarItem(title: "Map",
                                   image: UIImage(),
                                   selectedImage: UIImage())
        mapItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        let photoItem = UITabBarItem(title: "Camera",
                                     image: UIImage(),
                                     selectedImage: UIImage())
        photoItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        let settingsItem = UITabBarItem(title: "Settings",
                                     image: UIImage(),
                                     selectedImage: UIImage())
        settingsItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        
        mapVC.tabBarItem = mapItem
        photoVC.tabBarItem = photoItem
        settingsVC.tabBarItem = settingsItem
        
        let controllers = [mapVC, photoVC, settingsVC]
        
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        if let viewControllers = viewControllers {
            selectedViewController = viewControllers[0]
        }
    }
    
    private func configureView() {
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
}
