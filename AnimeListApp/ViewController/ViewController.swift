//
//  ViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    private var viewModel: ViewModel?

    private var animeListViewController = AnimeListViewController()

    // MARK: TODO fazer uma view com isso aqui
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PlaceHolder"
        return label
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        viewModel = ViewModel(delegate: self)
        setContraints()

        Task {
            await viewModel?.fetchAnimes()
            // RELOAD TABLE VIEW (QUE VAI PEDIR OS ANIMES PRO VIEW MODEL)
        }

    }
    func setContraints() {
        view.addSubview(label)
        view.addSubview(imageView)
        addChild(animeListViewController)
        view.addSubview(animeListViewController.view)
        animeListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -15),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animeListViewController.view.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 10),
            animeListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animeListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animeListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: ViewModelDelegate {
    func getImageUrl(url: URL) {
        imageView.sd_setImage(with: url)
    }

    func getTitleArray(title: String) {
        DispatchQueue.main.async {
            self.label.text = title
        }
    }
}
