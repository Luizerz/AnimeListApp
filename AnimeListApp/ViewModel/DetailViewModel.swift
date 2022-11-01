//
//  DetailViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 19/10/22.
//

import Foundation
import UIKit

class DetailViewModel {
    var model: Anime
    var delegate: DetailViewModelDelegate?

    init(with model: Anime) {
        self.model = model
    }

    func configureImageView(imageView: UIImageView) {
        let imageURL: URL
        imageURL = URL(string: model.images?.jpg?.imageUrl ?? "ERROR")!
        imageView.sd_setImage(with: imageURL)
    }

    func configureTextView(textView: UITextView) {
        let textAnime = model.synopsis
        textView.text = textAnime
    }

    func configureRating(labelView: UILabel) {
        let rating = model.score
        labelView.text = "Rating: \(rating ?? 0)"
    }

    func configureMalID(labelView: UILabel) {
        let textAnime = model.id
        labelView.text = "Mal ID: \(textAnime ?? 0)"
    }
    func configureEpisodes(labelView: UILabel) {
        let episodesLabel = model.episodes
        labelView.text = "Episodes: \(episodesLabel ?? 0)"
    }

    func configureSwitch(switchConfig: UISwitch) {
        let isOn = model.isOnMyList
        switchConfig.isOn = isOn
    }

    func changeSwitch(to isOn: Bool) {
        if isOn {
            model.isOnMyList.toggle()
            _ = CoreDataStack.shared.createAnimeEntity(animeData: model.animeData())
            delegate?.reloadTableView()
            do {
                try CoreDataStack.shared.context.save()
            } catch {
                print("nao criou")
            }
//            CoreDataStack.shared.printAllAnimeEntity()
        } else {
            CoreDataStack.shared.deleteAnimeEntity(anime: model.animeData())
            delegate?.reloadTableView()
            do {
                try CoreDataStack.shared.context.save()
            } catch {
                print("nao deletou")
            }
        }

    }

}
