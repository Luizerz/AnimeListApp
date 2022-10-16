//
//  AnimListViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

class AnimeListViewModel {

    weak var delegate: AnimeListDelegate?
    var animesData: [AnimeData]? {
        didSet {
            delegate?.willReloadData(bool: true)
        }
    }

    init(delegate: AnimeListDelegate) {
        self.delegate = delegate
    }

    func animeSeleted(indexPath: IndexPath){
        print(animesData?[indexPath.row].title ?? "error\(#function)")
    }

    func fetchAnimes() async {
        let anime = await API.getAnimeModel(url: Router.getTopAnimes)
        animesData = anime?.data
    }

    public var getCountData: Int {
        self.animesData?.count ?? 0
    }

}
