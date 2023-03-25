//
//  BaseCoordinator.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import UIKit

protocol BaseCoordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    var childCoordinators: [String: BaseCoordinator] { get set }
    var parentCoordinator: BaseCoordinator? { get set }
    
    func start()
}
