//
//  PhotoPreviewViewController.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import UIKit

class PhotoPreviewViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Properties
    var imageData: Data?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = imageData {
            imageView.image = UIImage(data: imageData)
        }
    }
    
    // MARK: Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        print(#function)
    }
}
