//
//  DatailViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 17/10/22.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var detailViewModel: DetailViewModel?

    @IBOutlet weak var animeImage: UIImageView!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var malID: UILabel!
    @IBOutlet weak var malRating: UILabel!
    @IBOutlet weak var savedSwitch: UISwitch!

    private var anime: AnimeData?

    @IBAction func saveSwitchAction(_ sender: UISwitch) {
        detailViewModel?.changeSwitch(to: sender.isOn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailText.showsVerticalScrollIndicator = true
        navigationItem.title = detailViewModel?.model.title
        detailViewModel?.configureImageView(imageView: animeImage)
        detailViewModel?.configureTextView(textView: detailText)
        detailViewModel?.configureRating(labelView: malRating)
        detailViewModel?.configureMalID(labelView: malID)
    }

}
