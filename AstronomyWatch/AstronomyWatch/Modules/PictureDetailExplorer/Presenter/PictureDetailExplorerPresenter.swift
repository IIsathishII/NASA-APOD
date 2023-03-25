//
//  PictureDetailExplorerPresenter.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation

protocol PictureDetailExplorerPresenterProtocol: AnyObject {
    func loadPictureOfTheDay(model: PictureOfDayModel)
    func handleLoadPictureOfTheDayDidFail()
}

class PictureDetailExplorerPresenter: PictureDetailExplorerPresenterProtocol {
    
    var coordinator: PictureDetailExplorerCoordinator
    var viewDelegate: PictureDetailExplorerViewProtocol?
    
    var model: PictureOfDayModel?
    
    init(coordinator: PictureDetailExplorerCoordinator) {
        self.coordinator = coordinator
    }
    
    func loadPictureOfTheDay(model: PictureOfDayModel) {
        self.model = model
        self.viewDelegate?.constructViewWith(Model: model)
    }
    
    func handleLoadPictureOfTheDayDidFail() {
        self.viewDelegate?.showErrorPopupWith(Message: "You are not connected to the Internet. We are showing the last image you viewed. Please connect back to the internet ")
    }
}
