//
//  ViewModel.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 11/10/22.
//

import UIKit

class ViewModel {

    weak var viewModelDelegate: ViewModelDelegate?
    init(){
//    (delegate: ViewModelDelegate) <- dentro do init
//        self.viewModelDelegate = delegate
    }
    func geralSelected()  {
        print(#function)
    }

    func myListSelected() {
        print(#function)
    }
}
