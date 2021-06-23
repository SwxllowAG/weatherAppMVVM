//
//  ModuleAssemblerProtocol.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

protocol ModuleAssembler {
    associatedtype ViewController
    var vc: ViewController { get }
    func setupViewModel()
}
