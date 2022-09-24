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
    }
    @IBAction func saveAction(_ sender: Any) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? ViewPhotoViewController {
            controller.photoImage = photoImageView.image
        }
    }
    

}
