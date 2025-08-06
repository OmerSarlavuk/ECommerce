//
//  HomeDetailViewCoordinator.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit

class HomeDetailViewCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: HomeViewCoordinator?
    var viewControllerRef: UIViewController?
    
    private var productModel: ProductModel
    
    init(navigationController: UINavigationController,
         parent: HomeViewCoordinator,
         productModel: ProductModel) {
        self.navigationController = navigationController
        self.parent = parent
        self.productModel = productModel
    }
    
    func start(animated: Bool) {
        let viewController = HomeDetailViewBuilder(coordinator: self,
                                                   topProduct: productModel).build()
        viewControllerRef = viewController
        navigationController.pushViewController(viewController,
                                                animated: animated)
    }
    
    func coordinatorDidFinish() {
        parent?.coordinatorDidFinish()
    }
}

extension HomeDetailViewCoordinator {
    func navigateCombination(animated: Bool, imageUrl: String) {
        parent?.navigateCombination(animated: animated,
                                    imageUrl: imageUrl)
    }
}
