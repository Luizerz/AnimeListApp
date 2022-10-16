//
//  API.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

struct Router {
    private init() { }

    static private let rootURL = "https://api.jikan.moe/v4"
    static let getTopAnimes = URL(string: "\(rootURL)/top/anime?type=tv")!
    static let getAnimes = URL(string: "\(rootURL)/anime")!
}

//API.getAnimeModel(url: Router.getAnimes)

class API {

    static func getAnimeModel(url: URL) async -> AnimeModel? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
//        print(url)
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let animeDecoded = try JSONDecoder().decode(AnimeModel.self, from: data)
            return animeDecoded
        } catch {
            print(error)
        }
        return nil
    }

    static func getAnimes(animeName: String) async -> AnimeModel? {
        let url = URL(string: "https://api.jikan.moe/v4/anime")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let animeDecoded = try JSONDecoder().decode(AnimeModel.self, from: data)
            return animeDecoded
        } catch {
            print(error)
        }
        return nil
    }

    static func getTopAnimes() async -> AnimeModel? {
        let url = URL(string: "https://api.jikan.moe/v4/top/anime?type=tv")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let animeDecoded = try JSONDecoder().decode(AnimeModel.self, from: data)
            return animeDecoded
        } catch {
            print(error)
        }
        return nil
    }

    static func getTopAnimeCompletion(completion: @escaping (AnimeModel) -> ()){
        let url = URL(string: "https://api.jikan.moe/v4/top/anime?type=tv")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                return
            }
            do {
                let animes = try JSONDecoder().decode(AnimeModel.self, from: responseData)
                completion(animes)
            } catch let error {
                print(error)
            }
        }

        task.resume()
    }
}