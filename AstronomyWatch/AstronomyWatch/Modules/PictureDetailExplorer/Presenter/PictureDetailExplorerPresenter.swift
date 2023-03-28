//
//  PictureDetailExplorerPresenter.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation

protocol PictureDetailExplorerPresenterProtocol: AnyObject {
    func loadPictureOfTheDay(model: PictureOfDayModel)
    func didStartLoading()
    func didEndLoading()
    func handleLoadPictureOfTheDayDidFail()
}

class PictureDetailExplorerPresenter: PictureDetailExplorerPresenterProtocol {
    
    var coordinator: PictureDetailExplorerCoordinator
    var viewDelegate: PictureDetailExplorerViewProtocol?
    
    var model: PictureOfDayModel?
    
    init(coordinator: PictureDetailExplorerCoordinator) {
        self.coordinator = coordinator
    }
    
    //Stores the model and asks view to be rendered
    func loadPictureOfTheDay(model: PictureOfDayModel) {
        self.model = model
        self.viewDelegate?.constructViewWith(Model: model)
    }
    
    //Handles failure to fetch picture of day by showing an error alert
    func handleLoadPictureOfTheDayDidFail() {
        self.viewDelegate?.showErrorPopupWith(Message: "You are not connected to the Internet. We are showing the last image you viewed. Please connect back to the internet ")
    }
    
    //Remote fetch of picture of day has begun
    func didStartLoading() {
        self.viewDelegate?.showLoader(true)
    }
    
    //Remote fetch of picture of day has ended
    func didEndLoading() {
        self.viewDelegate?.showLoader(false)
    }
}
