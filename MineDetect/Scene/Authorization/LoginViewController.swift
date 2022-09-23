//
//  LoginViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit

class LoginViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "loggedIn", sender: nil)
    }
}
