//
//  Anime.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 21/10/22.
//

import Foundation

struct Anime {
    let id: Int?
    let title: String?
    let episodes: Int?
    let score: Float?
    let synopsis: String?
    let images: ImageFormat?
    var isOnMyList: Bool

    init(_ animeData: AnimeData) {
        self.id = animeData.malId
        self.title = animeData.title
        self.episodes = animeData.episodes
        self.score = animeData.score
        self.synopsis = animeData.synopsis
        self.images = animeData.images
        self.isOnMyList = false
    }

    init(_ animeEntity: AnimeEntity) {
        self.id = Int(animeEntity.malID)
        self.title = animeEntity.title
        self.episodes = Int(animeEntity.episodes) // animeEntity.episodes
        self.score = animeEntity.malRating
        self.synopsis = animeEntity.detailText
        self.images = ImageFormat(
            jpg: ImageURL(
                largeImageUrl: nil,
                smallImageUrl: nil,
                imageUrl: animeEntity.animeImage
            )
        )
        self.isOnMyList = true
    }

    func animeData() -> AnimeData {
        AnimeData(
            malId: id,
            title: title,
            episodes: episodes,
            score: score,
            synopsis: synopsis,
            images: images
        )
    }
}
