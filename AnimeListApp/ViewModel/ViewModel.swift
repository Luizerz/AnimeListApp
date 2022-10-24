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

    var selectedSegmentedIndex: Int = 0 {
        didSet {
            // Começa evento de atualizar a view a partir do model
            Task {
                await viewModelDelegate?.loadAnimes(
                    with: selectedSegmentedIndex == 0 ? geralSelected() : myListSelected()
                )
            }
        }
    }

    // Metodos
    func select(segmentedIndex: Int) {
        self.selectedSegmentedIndex = segmentedIndex // fim do evento que atualiza model
    }

    func setAnimeSelected(at indexPath: IndexPath) {
        print(animes[indexPath.row].title ?? "")
        viewModelDelegate?.goToDetail(with: animes[indexPath.row])
        // enviar evento pra controller fazer transicao de tela via delegate
    }

    private func geralSelected() async -> [Anime] {
        let animeDatas = await API.getAnimeModel(url: Router.getTopAnimes)?.data ?? []
        self.animes = animeDatas.map({ animeData in
            return Anime(animeData)
        })
        // self.animes = animeDatas.map { Anime($0) }
        return animes
    }

    private func myListSelected() -> [Anime] {
        let minhaLista: [AnimeEntity] = CoreDataStack.shared.fetchAnimeEntity()
        self.animes = minhaLista.map({ minhaLista in
            return Anime(minhaLista)
        })
        return animes
    }
}
