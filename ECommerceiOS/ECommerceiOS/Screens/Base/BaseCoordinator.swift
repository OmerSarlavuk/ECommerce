//
//  BaseCoordinator.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit

final class BaseCoordinator: Coordinator, ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        // start screen
        navigateHome(animated: animated)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

extension BaseCoordinator {
    func navigateHome(animated: Bool) {
        let coordinator = HomeViewCoordinator(navigationController: navigationController,
                                              parent: self)
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
}
