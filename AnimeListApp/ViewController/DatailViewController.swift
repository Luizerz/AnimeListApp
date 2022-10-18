//
//  DatailViewController.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 17/10/22.
//

import UIKit

class DatailViewController: UIViewController {

    @IBOutlet weak var animeImage: UIImageView!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var tableView: UITableView!

    private var anime: AnimeData?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = anime?.title
    }
}
