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
    
    var location: Location?
    
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
        if let location = location,
           let imageData = MainManager.shared.pendingImageData,
           let image = UIImage(data: imageData),
           let compressedImageData = image.jpeg(.lowest) {
            let requestModel = AddMineRequestModel(location: location,
                                                   title: titleTextField.text ?? "",
                                                   userdID: "632ef0e8d628897e69af8fa8",
                                                   description: descriptionTextView.text ?? "",
                                                   image: compressedImageData)
            APIHandler.addMine(requestModel) { response in
                print(response)
            }
        }
       
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
