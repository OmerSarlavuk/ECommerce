//
//  SearchImageViewCoordinator.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit

class SearchImageViewCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: HomeViewCoordinator?
    var viewControllerRef: UIViewController?
    
    init(navigationController: UINavigationController,
         parent: HomeViewCoordinator) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start(animated: Bool) {
        let viewController = SearchImageViewBuilder(coordinator: self).build()
        viewControllerRef = viewController
        navigationController.pushViewController(viewController,
                                                animated: animated)
    }
    
    func coordinatorDidFinish() {
        parent?.coordinatorDidFinish()
    }
}
