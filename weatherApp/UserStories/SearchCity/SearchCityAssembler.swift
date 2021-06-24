//
//  SearchCityAssembler.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

class SearchCityModuleAssembler: ModuleAssembler {
    typealias ViewController = SearchCityViewController

    var view: ViewController

    init() {
        view = SearchCityViewController()
        setupViewModel()
    }

    internal func setupViewModel() {
        view.viewModel = SearchCityViewModel()
        view.viewModel.delegate = view
    }
}
