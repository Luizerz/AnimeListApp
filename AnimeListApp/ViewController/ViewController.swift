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

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private let animeListViewModel = AnimeListViewModel()
    private lazy var animeListViewController = AnimeListViewController(animeListViewModel: animeListViewModel)

    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel?.geralSelected()
        }
        if sender.selectedSegmentIndex == 1 {
            animeListViewModel.resetAnime()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        setContraints()
    }

    func setContraints() {
        addChild(animeListViewController)
        view.addSubview(animeListViewController.view)
        animeListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeListViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: 25),
            animeListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            animeListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animeListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
