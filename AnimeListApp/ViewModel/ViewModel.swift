//
//  ViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit

class ViewModel {

    // Binding
    weak var viewModelDelegate: ViewModelDelegate?

    // Model
    private var animes: [Anime] = []
    var loadTask: Task<Void, Never>?

    var selectedSegmentedIndex: Int = 0 {
        didSet {
            // Começa evento de atualizar a view a partir do model
            Task {
                let animeAux: [Anime] = []
                viewModelDelegate?.enableLoadingView()
                await viewModelDelegate?.loadAnimes(with: animeAux)
                DispatchQueue.main.async {
                    // Ending Task
                }
            }
            loadTask?.cancel()
            loadTask = Task {
                if let animes = try? await getAnimes(for: selectedSegmentedIndex) {
                    await viewModelDelegate?.loadAnimes(with: animes)
                }
            }
        }
    }

    // Metodos
    private func getAnimes(for selectedIndex: Int) async throws -> [Anime] {
        if selectedSegmentedIndex == 0 {
            return try await geralSelected()
        } else {
            return myListSelected()
        }
    }

    func select(segmentedIndex: Int) {
        self.selectedSegmentedIndex = segmentedIndex // fim do evento que atualiza model
    }

    func setAnimeSelected(at indexPath: IndexPath) {
        print(animes[indexPath.row].title ?? "")
        let fetchFromCoreData = CoreDataStack.shared.fetchAnimeEntity()
        for aux in 0..<fetchFromCoreData.count {
            if self.animes[indexPath.row].title == fetchFromCoreData[aux].title {
                print("On my list")
                self.animes[indexPath.row].isOnMyList = true
            }
        }
        viewModelDelegate?.goToDetail(with: animes[indexPath.row])

        // enviar evento pra controller fazer transicao de tela via delegate
    }

    private func geralSelected() async throws -> [Anime] {
        let animeDatas = try await API.getAnimeModel(url: Router.getTopAnimes)?.data ?? []
        self.animes = animeDatas.map({ animeData in
            return Anime(animeData)
        })
        // self.animes = animeDatas.map { Anime($0) }
        print("RETURN FROM API")
        return animes
    }

    private func myListSelected() -> [Anime] {
        print("COREDATA")
        let minhaLista: [AnimeEntity] = CoreDataStack.shared.fetchAnimeEntity()
        self.animes = minhaLista.map({ minhaLista in
            return Anime(minhaLista)
        })
        print("RETURN FROM COREDATA")
        return animes
    }

    func searchAnime(animeName: String) async throws -> [Anime] {
        let animeName = animeName.replacingOccurrences(of: " ", with: "-")
        let url: URL = URL(string: "https://api.jikan.moe/v4/anime?q=\(animeName)&type=tv")!
        let animeDatas = try await API.getAnimeModel(url: url)?.data ?? []
        self.animes = animeDatas.map({ animeData in
            return Anime(animeData)
        })
        // self.animes = animeDatas.map { Anime($0) }
        print("RETURN FROM API")
        return animes
    }
}
