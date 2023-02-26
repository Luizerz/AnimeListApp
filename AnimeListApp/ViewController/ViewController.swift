//
//  ViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit
import Lottie
import SDWebImage

class ViewController: UIViewController {

    // View Model
    private var viewModel: ViewModel = ViewModel()

    // View
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private lazy var animeListViewController = AnimeListViewController()
    private lazy var searchBar = UISearchController(searchResultsController: nil)
    let emptyListView: LottieAnimationView = {
        let view = LottieAnimationView(asset: "blink")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.play()
        return view
    }()
    let emptyAnimeListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Não há Animes em sua lista."
        label.numberOfLines = 0
        return label
    }()
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
        // MARK: swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        rightSwipe.direction = .right
        animeListViewController.view.addGestureRecognizer(rightSwipe)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        leftSwipe.direction = .left
        animeListViewController.view.addGestureRecognizer(leftSwipe)

        //
        animeListViewController.animeSelected = { [weak self] indexPath in
            self?.viewModel.setAnimeSelected(at: indexPath)
        }

        addChild(animeListViewController)
        view.addSubview(animeListViewController.view)
        view.addSubview(emptyListView)
        view.addSubview(emptyAnimeListLabel)
        setContraints()
        viewModel.viewModelDelegate = self
        // searchBar
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Procure um Anime"
        navigationItem.searchController = searchBar
    }
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            viewModel.swipeToRight()
            segmentedControl.selectedSegmentIndex = 1
        }
        if gesture.direction == .left {
            viewModel.swipeToLeft()
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    func setContraints() {
        animeListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeListViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 25),
            animeListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            animeListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animeListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emptyListView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
            emptyListView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.1),
            emptyListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyAnimeListLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            emptyAnimeListLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            emptyAnimeListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            emptyAnimeListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100)
        ])
    }
}

extension ViewController: ViewModelDelegate {

    func disableLoadingView() {
        DispatchQueue.main.async {
            self.animeListViewController.loadingView.isHidden = true
            self.emptyListView.isHidden = false
            self.emptyAnimeListLabel.isHidden = false
        }
    }

    func enableLoadingView() {
        DispatchQueue.main.async {
            self.animeListViewController.loadingView.isHidden = false
            self.emptyListView.isHidden = true
            self.emptyAnimeListLabel.isHidden = true
        }
    }

    func loadAnimes(with animes: [Anime]) async {
        if !animes.isEmpty {
            animeListViewController.loadingView.isHidden = true
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

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var animeArray: [Anime] = []

        self.timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            if self?.viewModel.selectedSegmentedIndex == 0 && text != "" {
                Task {
                    animeArray = try await self!.viewModel.searchAnime(animeName: text)
                    self?.animeListViewController.animes = animeArray
                    self?.animeListViewController.tableView.reloadData()
                }
            } else if self?.viewModel.selectedSegmentedIndex == 1 {
                if text != "" {
                    animeArray = self?.viewModel.searchAnimeFromCD(animeName: text) ?? []
                    self?.animeListViewController.animes = animeArray
                    self?.animeListViewController.tableView.reloadData()
                } else {
                    animeArray = self?.viewModel.refreshCD() ?? []
                    self?.animeListViewController.animes = animeArray
                    self?.animeListViewController.tableView.reloadData()
                }
            }

        }
    }
}
