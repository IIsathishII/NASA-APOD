//
//  PictureDetailExplorerCoordinator.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import UIKit

class PictureDetailExplorerCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [String: BaseCoordinator] = [:]
    weak var parentCoordinator: BaseCoordinator?
    
    init(navigationController: UINavigationController, parent: BaseCoordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parent
    }
    
    func start() {
        self.showDetailedView()
    }
    
    func showDetailedView() {
        let presenter = PictureDetailExplorerPresenter(coordinator: self)
        let viewController = PictureDetailExplorerViewController()
        let interactor = PictureDetailExplorerInteractor(dataService: PictureDetailExplorerDataService(), fileManager: AWFileManager())
        
        viewController.interactorDelegate = interactor
        interactor.presenterDelegate = presenter
        presenter.viewDelegate = viewController
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
