//
//  ViewController.swift
//  SwiftVids
//
//  Created by Paulo Fierro on 8/27/20.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

// MARK: - Networking

extension ViewController {

    // Loads the data and displays it
    private func loadData() {
        Networking().loadData { [weak self] result in
            switch result {
            case .success(let response):
                self?.showVideos(response.items)

            case .failure(let error):
                self?.showError(error as? String)
            }
        }
    }
}

// MARK: - UI

extension ViewController {

    private func showError(_ error: String?) {
        let alert = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        show(alert, sender: nil)
    }

    private func showVideos(_ videos: [VideoItem]) {
        for item in videos {
            let viewController = VideoItemViewController(nibName: "\(VideoItemViewController.self)", bundle: nil)
            viewController.videoItem = item

            // Add the view controller as a child and add its view to the stack view
            viewController.willMove(toParent: self)
            addChild(viewController)

            // Add the view to the stack
            //stackView.addSubview(viewController.view)
            stackView.addArrangedSubview(viewController.view)

            // Finish the transition to the parent
            viewController.didMove(toParent: self)

            // Listen for taps
            viewController.delegate = self
        }
    }
}

// MARK: - Video Item Delegate Methods

extension ViewController: VideoItemDelegate {

    func videoItemTapped(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
