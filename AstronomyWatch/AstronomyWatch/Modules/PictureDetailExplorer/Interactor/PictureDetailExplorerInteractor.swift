//
//  PictureDetailExplorerInteractor.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import Network

protocol PictureDetailExplorerInteractorProtocol: AnyObject {
    func startLoading()
}

class PictureDetailExplorerInteractor: PictureDetailExplorerInteractorProtocol {
    
    var presenterDelegate: PictureDetailExplorerPresenterProtocol?
    var urlSession = URLSession(configuration: .default)
    
    var fetchDidFail = false
    
    init() {
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
}

extension PictureDetailExplorerInteractor {
    
    private func fetchPictureOfTheDay() {
        guard let request = createPictureOfTheDayRequest() else { return }
        self.presenterDelegate?.didStartLoading()
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil || data == nil || (response as? HTTPURLResponse)?.statusCode != 200 {
                    self.fetchPictureModelDidFail()
                } else if let data = data {
                    if let model = try? JSONDecoder().decode(PictureOfDayModel.self, from: data) {
                        self.didFetchPictureModel(model: model)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func fetchPictureModelDidFail() {
        self.fetchDidFail = true
        if let model = UserDefaults.standard.pictureOfDayModel {
            self.presenterDelegate?.loadPictureOfTheDay(model: model)
            self.presenterDelegate?.handleLoadPictureOfTheDayDidFail()
        }
    }
    
    private func didFetchPictureModel(model: PictureOfDayModel) {
        if let url = model.hdurl {
            self.downloadImageFrom(URL: url) { success in
                DispatchQueue.main.async {
                    self.presenterDelegate?.didEndLoading()
                    if success {
                        UserDefaults.standard.pictureOfDayModel = model
                        self.presenterDelegate?.loadPictureOfTheDay(model: model)
                    }
                }
            }
        }
    }
    
    private func createPictureOfTheDayRequest() -> URLRequest? {
        guard var components = URLComponents(string: "https://api.nasa.gov/planetary/apod") else { return nil }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Bundle.main.getValueFromInfoPlist(ForKey: .NASAAPIKey)),
            URLQueryItem(name: "date", value: Date.getTodaysDateInAPIFriendlyFormat())
        ]
        guard let requestURL = components.url else { return nil}
        return URLRequest(url: requestURL)
    }
    
    private func downloadImageFrom(URL url: URL, completion: @escaping (Bool) -> ()) {
        if let destinationUrl = url.getLocalFileURL() {
            let request = URLRequest(url: url)
            let task = urlSession.downloadTask(with: request) { tempUrl, response, error in
                if let tempUrl = tempUrl {
                    do {
                        try FileManager.default.copyItem(at: tempUrl, to: destinationUrl)
                        completion(true)
                        return
                    } catch (let err) {
                        print("File copy failed! ", err)
                    }
                }
                completion(false)
            }
            task.resume()
        }
    }
}
