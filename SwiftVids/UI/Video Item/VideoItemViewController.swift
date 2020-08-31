//
//  VideoItemViewController.swift
//  SwiftVids
//
//  Created by Paulo Fierro on 8/27/20.
//

import Kingfisher
import UIKit

protocol VideoItemDelegate: class {
    func videoItemTapped(url: URL)
}

final class VideoItemViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    // The video item data to display
    var videoItem: VideoItem!

    // The delegate listening to our messages
    weak var delegate: VideoItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = videoItem.title
        descriptionLabel.text = videoItem.description
        imageView.kf.setImage(with: videoItem.thumbnail)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc
    private func buttonTapped() {
        guard let url = videoItem.videoURL else {
            return
        }
        delegate?.videoItemTapped(url: url)
    }
}
