//
//  MineDetailsViewController.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import UIKit

class MineDetailsViewController: BaseViewController {

    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var sendButton: UIButton!
    
    var location: Location?
    var address: String?
    
    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                showActivityIndicator()
                sendButton.isEnabled = false
            } else {
                hideActivityIndicator()
            }
        }
    }
    
    private var isValidated: Bool {
        return MainManager.shared.pendingImageData != nil && location != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        locationLabel.text = address ?? "Поверніться на мапу та спробуйте вказати адресу ще раз"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureImageView()
        sendButton.isEnabled = isValidated
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
           let compressedImageData = image.jpeg(.medium) {
            isLoading = true
            let requestModel = AddMineRequestModel(location: location,
                                                   title: titleTextField.text ?? "",
                                                   userdID: Storage.shared.user?.userId ?? "",
                                                   description: descriptionTextView.text ?? "",
                                                   image: compressedImageData)
            APIHandler.addMine(requestModel) { [weak self] response in
                print(response ?? "⚠️ APIHandler.addMine response is nil")
                MainManager.shared.clear()
                self?.isLoading = false
                self?.navigationController?.popViewController(animated: true)
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
