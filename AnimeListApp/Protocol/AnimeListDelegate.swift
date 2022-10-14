//
//  AnimeListProtocol.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 14/10/22.
//

import Foundation

protocol AnimeListDelegate: AnyObject {
    func willReloadData(bool: Bool)
}
