//
//  MineDetailsViewController.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import UIKit

class MineDetailsViewController: BaseViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureImageView()
    }
    
    private func configureImageView() {
        if let imageData = MainManager.shared.pendingImageData {
            photoImageView.image = UIImage(data: imageData)
        }
    }

    @IBAction func takePhotoAction(_ sender: Any) {
        performSegue(withIdentifier: "takePhoto", sender: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
}

extension MineDetailsViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ViewPhotoViewController {
            controller.photoImage = photoImageView.image
        }
    }
}
