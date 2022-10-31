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
    private lazy var searchBar = UISearchController(searchResultsController: nil)
    var timer: Timer?

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

        animeListViewController.animeSelected = { [weak self] indexPath in
            self?.viewModel.setAnimeSelected(at: indexPath)
        }

        addChild(animeListViewController)
        view.addSubview(animeListViewController.view)
        setContraints()
        viewModel.viewModelDelegate = self

        // searchBar
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Procure um Anime"
        navigationItem.searchController = searchBar
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

    func enableLoadingView() {
        DispatchQueue.main.async {
            self.animeListViewController.testeView.isHidden = false
        }
    }

    func loadAnimes(with animes: [Anime]) async {
        if !animes.isEmpty {
            animeListViewController.testeView.isHidden = true
        }
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

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var animeArray: [Anime] = []

        self.timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            if self?.viewModel.selectedSegmentedIndex == 0 {
                if text == "" {
                    self!.viewModel.select(segmentedIndex: 0)
                } else {
                    Task {
                        animeArray = try await self!.viewModel.searchAnime(animeName: text)
                        print(animeArray)
                        self?.animeListViewController.animes = animeArray
                        self?.animeListViewController.tableView.reloadData()
                    }
                }
            }
        }

        print(text)

//        let animeArray = animeListViewController.animes
//        var filteredAnimes: [Anime] = []
//
//        for anime in animeArray {
//            guard let animeTitle = anime.title else {return}
//            if animeTitle.contains(text) {
//                filteredAnimes.append(anime)
//            }
//        }
//        print(filteredAnimes)
    }
}
