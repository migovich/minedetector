//
//  BaseViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    private var container: UIView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - Activity Indicator
extension BaseViewController {
    func showActivityIndicator() {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.color = .systemBlue
        
        container.addSubview(activityIndicator)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.container.removeFromSuperview()
        }
    }
}
