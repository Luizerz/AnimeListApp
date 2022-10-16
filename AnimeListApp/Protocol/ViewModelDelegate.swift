//
//  File.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

protocol ViewModelDelegate: AnyObject {

    func getTitleArray(title: String)
    func getImageUrl(url: URL)
}