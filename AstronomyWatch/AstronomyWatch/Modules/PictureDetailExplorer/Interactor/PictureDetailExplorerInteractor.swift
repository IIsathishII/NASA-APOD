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
        
        //Registers a callback to be called when network status changes
        NetworkMonitor.shared.setCallback { [weak self] status in
            guard let self = self else { return }
            if status == .satisfied, self.fetchDidFail {
                self.fetchPictureOfTheDay()
                self.fetchDidFail = false
            }
        }
    }
    
    //Decides how to fetch APOD. If cached and valid, uses local version. Fetches from remote otherwise
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
    
    //Makes the request to fetch APOD
    func fetchPictureOfTheDay() {
        self.presenterDelegate?.didStartLoading()
        self.dataService.fetchPOD { model in
            self.didFetchPictureModel(model: model)
        } onError: {
            self.fetchPictureModelDidFail()
        }

    }
    
    //Handles when the APOD fetch fails
    func fetchPictureModelDidFail() {
        self.fetchDidFail = true
        if let model = UserDefaults.standard.pictureOfDayModel {
            self.presenterDelegate?.loadPictureOfTheDay(model: model)
            self.presenterDelegate?.handleLoadPictureOfTheDayDidFail()
        }
    }
    
    //Once APOD is fetched, downloads the file from the url and stores it locally
    func didFetchPictureModel(model: PictureOfDayModel) {
        if let url = model.url, self.isValidImageFormat(ext: url.pathExtension) {
            self.performFileDownload(url: url) { tempURL in
                if self.handleDownloadedFile(remoteURL: url, tempURL: tempURL) {
                    self.loadPictureOfDay(model: model)
                }
            } onError: {
                
            }
        } else {
            self.loadPictureOfDay(model: model)
        }
    }
    
    func performFileDownload(url: URL, onSuccess: @escaping (URL) -> (), onError: @escaping () -> ()) {
        self.dataService.downloadPOD(url: url) { url in
            onSuccess(url)
        } onError: {
            onError()
        }
    }
    
    func handleDownloadedFile(remoteURL: URL, tempURL: URL) -> Bool {
        if let destinationUrl = remoteURL.getLocalFileURL() {
            do {
                try self.fileManager.removeFilesFromDocumentDirectory()
                try self.fileManager.copyItem(at: tempURL, to: destinationUrl)
                                
                return true
            } catch (let err) {
                print("File copy failed! ", err)
            }
        }
        return false
    }
    
    func loadPictureOfDay(model: PictureOfDayModel) {
        self.presenterDelegate?.didEndLoading()
        UserDefaults.standard.pictureOfDayModel = model
        self.presenterDelegate?.loadPictureOfTheDay(model: model)
    }
    
    //APOD supports only three formats
    func isValidImageFormat(ext: String) -> Bool {
        ext == "jpg" || ext == "png" || ext == "jpeg"
    }
}
