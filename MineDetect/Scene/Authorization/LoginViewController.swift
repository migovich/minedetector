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
            let userName = Storage.shared.user?.name ?? ""
            nameTextField.text = userName
            APIHandler.login(LoginRequestModel(userName: userName)) { response in
                print("login:")
                print(response)
                //Storage.shared.user?.userId = response.userId
                //performSegue(withIdentifier: "loggedIn", sender: nil)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let userName = nameTextField.text, userName.count >= 3 {
            Storage.shared.user?.name = userName
            // api request { userId in
            //  Storage.shared.user?.userId = userId
            //}
            let token = Storage.shared.user?.deviceToken ?? ""
            APIHandler.signup(SignupRequestModel(name: userName, deviceToken: token)) { response in
                print("signup:")
                print(response)
            }
            performSegue(withIdentifier: "loggedIn", sender: nil)
        }
    }
}
