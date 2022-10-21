//
//  AnimeListViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import UIKit

class AnimeListViewController: UIViewController {

    // Refatorar para os metodos do delegate e datasource usarem uma closure (futuro, talvez bridge)
    var animes: [Anime] = []

    // closure
    var animeSeleted: (IndexPath) -> Void = { _ in }

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "AnimeListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func loadView() {
        self.view = tableView
        self.view.layer.cornerRadius = 25
    }

}

extension AnimeListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anime = animes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? AnimeListViewCell else { return UITableViewCell() }
        cell.configure(with: anime)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animeSeleted(indexPath)
    }
}
