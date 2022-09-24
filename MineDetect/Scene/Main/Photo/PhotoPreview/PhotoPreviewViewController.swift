//
//  PhotoPreviewViewController.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import UIKit

protocol PhotoPreviewViewControllerDelegate: AnyObject {
    func didConfirmPhoto()
}

class PhotoPreviewViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Properties
    weak var delegate: PhotoPreviewViewControllerDelegate?
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
        MainManager.shared.pendingImageData = imageData
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didConfirmPhoto()
        }
    }
}
