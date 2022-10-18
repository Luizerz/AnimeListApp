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
    private var animes: [AnimeData] = []

    var selectedSegmentedIndex: Int = 0 {
        didSet {
            // Começa evento de atualizar a view a partir do model
            Task {
                await viewModelDelegate?.loadAnimes(with: selectedSegmentedIndex == 0 ? geralSelected() : myListSelected())
            }
        }
    }

    // Metodos
    func select(segmentedIndex: Int) {
        self.selectedSegmentedIndex = segmentedIndex // fim do evento que atualiza model
    }

    func setAnimeSelected(at indexPath: IndexPath) {
        print(animes[indexPath.row].title ?? "")
        
        // enviar evento pra controller fazer transicao de tela via delegate
    }

    private func geralSelected() async -> [AnimeData] {
        animes = await API.getAnimeModel(url: Router.getTopAnimes)?.data ?? []
        return animes
    }

    private func myListSelected() async -> [AnimeData] {
        animes = await API.getAnimeModel(url: Router.getAnimes)?.data ?? []
        return animes
    }
}
