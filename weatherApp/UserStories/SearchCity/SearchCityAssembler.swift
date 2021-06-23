//
//  SearchCityAssembler.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

class SearchCityModuleAssembler: ModuleAssembler {
    typealias ViewController = SearchCityViewController
    
    var vc: ViewController
    
    init() {
        vc = SearchCityViewController()
        setupViewModel()
    }
    
    internal func setupViewModel() {
        vc.viewModel = SearchCityViewModel()
        vc.viewModel.delegate = vc
    }
}
