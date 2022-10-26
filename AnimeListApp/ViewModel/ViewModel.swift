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
        viewModelDelegate?.goToDetail(with: animes[indexPath.row])
        // enviar evento pra controller fazer transicao de tela via delegate
    }

    private func geralSelected() async throws -> [Anime] {
        print("API")
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
}
