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
        labelView.text = "Mal_ID: \(textAnime ?? 0)"
    }

    func configureSwitch(switch: UISwitch) {
        // busca no coredata
        // se existir, seta o valor inicial pra true
        // se nao, seta pra false
    }

    func changeSwitch(to isOn: Bool) {
        if isOn {
            // persiste no coredata
        } else {
            // remove do coredata
        }
    }

}
