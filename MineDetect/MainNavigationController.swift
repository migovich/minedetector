//
//  MainNavigationController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    private var alreadyLoggedIn: Bool = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Handle alreadyLoggedIn state
        if alreadyLoggedIn {
            performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
}
