//
//  ViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit

class ViewModel {

    weak var viewModelDelegate: ViewModelDelegate?

    init(delegate: ViewModelDelegate){
        self.viewModelDelegate = delegate
    }

    func fetchAnimes() async {
        let anime = await API.getAnimeModel(url: Router.getTopAnimes)
        self.viewModelDelegate?.getTitleArray(title: anime?.data[0].title ?? "ERROR")
        self.viewModelDelegate?.getImageUrl(url: URL(string: anime?.data[0].images?.jpg?.image_url ?? "erro")!)
    }
}
