//
//  HomeViewCoordinator.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit

class HomeViewCoordinator: ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parent: BaseCoordinator?
    private var viewControllerRef: UIViewController?
    
    init(navigationController: UINavigationController,
         parent: BaseCoordinator?) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start(animated: Bool) {
        let homeViewController = HomeViewBuilder(coordinator: self).build()
        viewControllerRef = homeViewController
        navigationController.pushViewController(homeViewController,
                                                animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}

extension HomeViewCoordinator {
    func navigateHomeDetail(animated: Bool,
                            productModel: ProductModel) {
        let coordinator = HomeDetailViewCoordinator(navigationController: navigationController,
                                                    parent: self,
                                                    productModel: productModel)
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
    
    func navigateCombination(animated: Bool, imageUrl: String) {
        let coordinator = CombinationViewCoordinator(navigationController: navigationController,
                                                     parent: self,
                                                     imageUrl: imageUrl)
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
    
    func navigateSearchImage(animated: Bool) {
        let coordinator = SearchImageViewCoordinator(navigationController: navigationController,
                                                     parent: self)
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
}
