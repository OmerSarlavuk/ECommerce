//
//  CombinationViewCoordinator.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

class CombinationViewCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: HomeViewCoordinator?
    var viewControllerRef: UIViewController?
    private var imageUrl: String
    
    init(navigationController: UINavigationController,
         parent: HomeViewCoordinator,
         imageUrl: String) {
        self.navigationController = navigationController
        self.parent = parent
        self.imageUrl = imageUrl
    }
    
    func start(animated: Bool) {
        let viewController = CombinationViewBuilder(coordinator: self,
                                                    imageUrl: imageUrl).build()
        viewControllerRef = viewController
        navigationController.pushViewController(viewController,
                                                animated: animated)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}
