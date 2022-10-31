//
//  File.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func loadAnimes(with animes: [Anime]) async
    func goToDetail(with anime: Anime)
    func enableLoadingView()
}
