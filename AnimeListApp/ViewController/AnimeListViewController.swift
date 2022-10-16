//
//  AnimeListViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import UIKit

class AnimeListViewController: UIViewController {

    private lazy var animeListViewModel = AnimeListViewModel(delegate: self)

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "AnimeListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func loadView() {
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await animeListViewModel.fetchAnimes()
//            tableView.reloadData() // pode melhorar usand binding
        }
    }
}

extension AnimeListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeListViewModel.getCountData
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anime = animeListViewModel.animesData![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnimeListViewCell
        cell.configure(with: anime)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animeListViewModel.animeSeleted(indexPath: indexPath)
    }
}

extension AnimeListViewController: AnimeListDelegate {
    func willReloadData(bool: Bool) {
        if bool {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
