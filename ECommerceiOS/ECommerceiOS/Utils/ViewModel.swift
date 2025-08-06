//
//  ViewModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Foundation

public protocol ViewModel {
    //// Title of current  ViewController
    var title: String? { get }
    
    ////  Binds to Controller's viewDidLoad
    func start(with data: Any?)
}

public extension ViewModel {
    var title: String? { nil }
    
    func start(with data: Any?) { }
}
