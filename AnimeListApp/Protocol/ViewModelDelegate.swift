//
//  File.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func loadAnimes(with animes: [AnimeData]) async
    func goToDetail(with anime: AnimeData)
}
