//
//  MineDetailsViewController.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import UIKit

class MineDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.text = ""
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
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
