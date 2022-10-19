//
//  DatailViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 17/10/22.
//

import UIKit

class DetailViewController: UIViewController {

    var detailViewModel: DetailViewModel?

    @IBOutlet weak var animeImage: UIImageView!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var malID: UILabel!
    @IBOutlet weak var malRating: UILabel!
    @IBOutlet weak var savedSwitch: UISwitch!

    private var anime: AnimeData?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = detailViewModel?.model.title
        animeImage = detailViewModel?.configureImageView(imageView: animeImage)
        detailText = detailViewModel?.configureTextView(textView: detailText)
        malRating = detailViewModel?.configureRating(labelView: malRating)
        malID = detailViewModel?.configureMalID(labelView: malID)
    }
}
