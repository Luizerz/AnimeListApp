//
//  AnimeListViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import UIKit
import Lottie

class AnimeListViewController: UIViewController {

    // Refatorar para os metodos do delegate e datasource usarem uma closure (futuro, talvez bridge)

    // closure
    var animeSelected: (IndexPath) -> Void = { _ in }
    var animes: [Anime] = []

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "AnimeListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()

    let testeView: LottieAnimationView = {
        let view = LottieAnimationView(asset: "loading")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.play()
        return view
    }()

    override func loadView() {
        self.view = tableView
        self.view.layer.cornerRadius = 25
        tableView.addSubview(testeView)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            testeView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            testeView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            testeView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
        ])
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
        animeSelected(indexPath)
    }
}
