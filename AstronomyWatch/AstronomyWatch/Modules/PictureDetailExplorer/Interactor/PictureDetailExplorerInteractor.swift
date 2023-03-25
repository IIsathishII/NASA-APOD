//
//  PictureDetailExplorerInteractor.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation

protocol PictureDetailExplorerInteractorProtocol: AnyObject {
    func startLoading()
}

class PictureDetailExplorerInteractor: PictureDetailExplorerInteractorProtocol {
    
    var presenterDelegate: PictureDetailExplorerPresenterProtocol?
    var urlSession = URLSession(configuration: .default)
    
    init() {
        
    }
    
    func startLoading() {
        if let model = UserDefaults.standard.pictureOfDayModel, model.date == Date.getTodaysDateInAPIFriendlyFormat() {
            presenterDelegate?.loadPictureOfTheDay(model: model)
        } else {
            fetchPictureOfTheDay()
        }
    }
}

extension PictureDetailExplorerInteractor {
    
    private func fetchPictureOfTheDay() {
        guard let request = createPictureOfTheDayRequest() else { return }
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                if let model = try? JSONDecoder().decode(PictureOfDayModel.self, from: data) {
                    DispatchQueue.main.async {
                        self.didFetchPictureModel(model: model)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func didFetchPictureModel(model: PictureOfDayModel) {
        if let url = model.hdurl {
            self.downloadImageFrom(URL: url) { success in
                DispatchQueue.main.async {
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
