//
//  ViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    // View Model
    private var viewModel: ViewModel = ViewModel()

    // View
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private lazy var animeListViewController = AnimeListViewController()

    // Actions
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        viewModel.select(segmentedIndex: sender.selectedSegmentIndex)
    }

    override func viewWillAppear(_ animated: Bool) {
        animeListViewController.tableView.reloadData()
        viewModel.selectedSegmentedIndex = segmentedControl.selectedSegmentIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemOrange

        animeListViewController.animeSeleted = { [weak self] indexPath in
            self?.viewModel.setAnimeSelected(at: indexPath)
        }

        addChild(animeListViewController)
        view.addSubview(animeListViewController.view)
        setContraints()
        viewModel.viewModelDelegate = self
        viewModel.selectedSegmentedIndex = 0

    }

    func setContraints() {
        animeListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeListViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 25),
            animeListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            animeListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animeListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}

extension ViewController: ViewModelDelegate {
    func loadAnimes(with animes: [Anime]) async {
        print("Atualiza Animes")
        animeListViewController.animes = animes
        animeListViewController.tableView.reloadData()
    }

    func goToDetail(with anime: Anime) {
        guard let detailViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                fatalError("Unable to Instantiate Quotes View Controller")
            }
        let detail = DetailViewModel(with: anime)
        detail.delegate = self
        detailViewController.detailViewModel = detail
        detailViewController.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.pushViewController(detailViewController, animated: true)
        }

}

extension ViewController: DetailViewModelDelegate {
    func reloadTableView() {
        animeListViewController.tableView.reloadData()
    }
}
