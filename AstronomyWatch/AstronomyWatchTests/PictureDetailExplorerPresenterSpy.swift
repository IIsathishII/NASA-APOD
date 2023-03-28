//
//  PictureDetailExplorerPresenterSpy.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 28/03/23.
//

import Foundation
@testable import AstronomyWatch

class PictureDetailExplorerPresenterSpy: PictureDetailExplorerPresenterProtocol {
    
    var didLoadPicture = false
    var loadingStarted = false
    var loadingEnded = false
    var didHandlePODFail = false
    
    func loadPictureOfTheDay(model: PictureOfDayModel) {
        self.didLoadPicture = true
    }
    
    func didStartLoading() {
        self.loadingStarted = true
    }
    
    func didEndLoading() {
        self.loadingEnded = true
    }
    
    func handleLoadPictureOfTheDayDidFail() {
        self.didHandlePODFail = true
    }
}
