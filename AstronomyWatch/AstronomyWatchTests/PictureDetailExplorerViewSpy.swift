//
//  PictureDetailExplorerViewSpy.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 27/03/23.
//

import Foundation
@testable import AstronomyWatch

class PictureDetailExplorerViewSpy: PictureDetailExplorerViewProtocol {
    
    var didConstructPODView = false
    var didShowError = false
    var setLoaderValue = false
    
    func constructViewWith(Model model: PictureOfDayModel) {
        self.didConstructPODView = true
    }
    
    func showErrorPopupWith(Message message: String) {
        self.didShowError = true
    }
    
    func showLoader(_ value: Bool) {
        self.setLoaderValue = true
    }
}
