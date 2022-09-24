//
//  ViewPhotoViewController.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import UIKit

class ViewPhotoViewController: UIViewController {
    var photoImage: UIImage?
    @IBOutlet weak var photo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = photoImage {
            photo.image = image
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func okAction(_ sender: Any) {
       // dismiss(animated: true)
        navigationController?.popViewController(animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
