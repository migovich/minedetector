//
//  MineInfoViewController.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import UIKit

class MineInfoViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Computed properties
    var model: Model?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        titleLabel.text = model?.title ?? ""
        descriptionLabel.text = model?.description ?? ""
        imageView.downloaded(from: model?.imageUrl ?? "")
    }
    
    // MARK: Helpers
    struct Model {
        let title: String?
        let description: String?
        let imageUrl: String?
    }
}
