//
//  DetailViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 19/10/22.
//

import Foundation
import UIKit

class DetailViewModel {
    var model: AnimeData

    init(with model: AnimeData){
        self.model = model
    }

    func configureImageView(imageView: UIImageView) -> UIImageView {
        let imageURL: URL
        imageURL = URL(string: model.images?.jpg?.image_url ?? "ERROR")!
        imageView.sd_setImage(with: imageURL)
        return imageView
    }

    func configureTextView(textView: UITextView) -> UITextView {
        let textAnime = model.synopsis
        textView.text = textAnime
        return textView
    }

    func configureRating(labelView: UILabel) -> UILabel {
        let rating = model.score
        labelView.text = "Rating: \(rating ?? 0)"
        return labelView
    }

    func configureMalID(labelView: UILabel) -> UILabel {
        let textAnime = model.mal_id
        labelView.text = "Mal_ID: \(textAnime ?? 0)"
        return labelView
    }

}
