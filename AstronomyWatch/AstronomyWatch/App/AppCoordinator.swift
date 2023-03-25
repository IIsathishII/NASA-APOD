//
//  AppCoordinator.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [String: BaseCoordinator] = [:]
    weak var parentCoordinator: BaseCoordinator? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let pictureExplorerCoordinator = PictureDetailExplorerCoordinator(navigationController: self.navigationController, parent: self)
        self.childCoordinators["pictureExplorer"] = pictureExplorerCoordinator
        pictureExplorerCoordinator.start()
    }
}
