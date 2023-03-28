//
//  PictureDetailExplorerInteractor.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import Network
import UIKit

protocol PictureDetailExplorerInteractorProtocol: AnyObject {
    func startLoading()
    func getImageFor(Path path: String) -> UIImage?
}

class PictureDetailExplorerInteractor: PictureDetailExplorerInteractorProtocol {
    
    var presenterDelegate: PictureDetailExplorerPresenterProtocol?
    var dataService: PictureDetailExplorerDataServiceProtocol
    var fileManager: AWFileManagerProtocol
    
    var fetchDidFail = false
    
    init(dataService: PictureDetailExplorerDataServiceProtocol, fileManager: AWFileManagerProtocol) {
        self.dataService = dataService
        self.fileManager = fileManager
        
        NetworkMonitor.shared.setCallback { [weak self] status in
            guard let self = self else { return }
            if status == .satisfied, self.fetchDidFail {
                self.fetchPictureOfTheDay()
                self.fetchDidFail = false
            }
        }
    }
    
    func startLoading() {
        if let model = UserDefaults.standard.pictureOfDayModel, model.date == Date.getTodaysDateInAPIFriendlyFormat() {
            presenterDelegate?.loadPictureOfTheDay(model: model)
        } else {
            if NetworkMonitor.shared.isReachable {
                fetchPictureOfTheDay()
            } else {
                fetchPictureModelDidFail()
            }
            // Handle scenario where phone is not connected to internet and app is opened for the first time.
        }
    }
    
    func getImageFor(Path path: String) -> UIImage? {
        UIImage(contentsOfFile: path)
    }
}

extension PictureDetailExplorerInteractor {
    
    func fetchPictureOfTheDay() {
        self.presenterDelegate?.didStartLoading()
        self.dataService.fetchPOD { model in
            self.didFetchPictureModel(model: model)
        } onError: {
            self.fetchPictureModelDidFail()
        }

    }
    
    func fetchPictureModelDidFail() {
        self.fetchDidFail = true
        if let model = UserDefaults.standard.pictureOfDayModel {
            self.presenterDelegate?.loadPictureOfTheDay(model: model)
            self.presenterDelegate?.handleLoadPictureOfTheDayDidFail()
        }
    }
    
    func didFetchPictureModel(model: PictureOfDayModel) {
        if let url = model.url, self.isValidImageFormat(ext: url.pathExtension) {
            self.dataService.downloadPOD(url: url) { tempURL in
                if let destinationUrl = url.getLocalFileURL() {
                    do {
                        try self.fileManager.removeFilesFromDocumentDirectory()
                        try self.fileManager.copyItem(at: tempURL, to: destinationUrl)
                        
                        self.loadPictureOfDay(model: model)
                    } catch (let err) {
                        print("File copy failed! ", err)
                    }
                }
            } onError: {
                
            }
        } else {
            self.loadPictureOfDay(model: model)
        }
    }
    
    func loadPictureOfDay(model: PictureOfDayModel) {
        self.presenterDelegate?.didEndLoading()
        UserDefaults.standard.pictureOfDayModel = model
        self.presenterDelegate?.loadPictureOfTheDay(model: model)
    }
    
    func isValidImageFormat(ext: String) -> Bool {
        ext == "jpg" || ext == "png" || ext == "jpeg"
    }
}
//
