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
        if Storage.shared.user?.name != nil {
            // performSegue(withIdentifier: "loggedIn", sender: nil)
            nameTextField.text = Storage.shared.user?.name
        }
        
    }
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let userName = nameTextField.text, userName.count >= 3 {
            Storage.shared.user?.name = userName
            // api request { userId in
            //  Storage.shared.user?.userId = userId
            //}
            performSegue(withIdentifier: "loggedIn", sender: nil)
        }
    }
}
