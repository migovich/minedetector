//
//  BaseViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
}
