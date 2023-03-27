//
//  PictureDetailExplorerInteractorMock.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 27/03/23.
//

import Foundation
@testable import AstronomyWatch
import UIKit

class PictureDetailExplorerInteractorMock: PictureDetailExplorerInteractorProtocol {
    var didBeginLoading: Bool = false
    
    func startLoading() {
        self.didBeginLoading = true
    }
    
    func getImageFor(Path path: String) -> UIImage? {
        return UIImage()
    }
}
