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
    
    // MARK: Stored properties [Public]
    var mineId: String?
    
    // MARK: Computed properties [Private]
    private var model: Model? {
        didSet {
            configureView()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getMineDetails()
    }
    
    // MARK: Functions [Private]
    private func configureView() {
        titleLabel.text = model?.title ?? ""
        descriptionLabel.text = model?.description ?? ""
        imageView.downloaded(from: model?.imageUrl ?? "")
    }
    
    private func getMineDetails() {
        guard let mineId = mineId else {
            return
        }
        APIHandler.getMineDetails(mineId) { [weak self] response in
            let mine = response?.first
            self?.model = Model(title: mine?.title,
                                description: mine?.description,
                                imageUrl: mine?.photoURL)
        }
    }
    
    // MARK: Helpers
    struct Model {
        let title: String?
        let description: String?
        let imageUrl: String?
    }
}
