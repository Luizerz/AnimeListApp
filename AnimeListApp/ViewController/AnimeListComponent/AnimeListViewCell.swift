//
//  AnimeListViewCell.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import UIKit

class AnimeListViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var animeImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with anime: AnimeData) {
        label.text = anime.title
        animeImage.sd_setImage(with: URL(string: anime.images?.jpg?.image_url ?? "")!)
    }
    
}
