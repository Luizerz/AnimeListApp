//
//  AnimeModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

struct AnimeModel: Codable {
    let pagination: Pagination
    let data: [AnimeData]
}

struct Pagination: Codable {
    let lastVisiblePage: Int
    let hasNextPage: Bool
    let currentPage: Int
    let items: Items

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
        case items
    }
}

struct Items: Codable {
    let count, total, perPage: Int

    enum CodingKeys: String, CodingKey {
        case count, total
        case perPage = "per_page"
    }
}

struct AnimeData: Codable {
    let malId: Int?
    let title: String?
    let episodes: Int?
    let score: Float?
    let synopsis: String?
    let images: ImageFormat?

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title, episodes, score, synopsis, images
    }
}

struct ImageFormat: Codable {
    let jpg: ImageURL?
}

struct ImageURL: Codable {
    let largeImageUrl: String?
    let smallImageUrl: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case largeImageUrl = "large_image_url"
        case smallImageUrl = "small_image_url"
        case imageUrl = "image_url"
    }
}

/* let animeDataMock: [AnimeData] = [AnimeData(mal_id: nil,
 title: nil, episodes: nil, score: nil, synopsis: nil, images:  nil)]*/
