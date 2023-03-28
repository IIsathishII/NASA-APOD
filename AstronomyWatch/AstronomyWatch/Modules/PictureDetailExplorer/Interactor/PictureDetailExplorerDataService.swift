//
//  PictureDetailExplorerDataService.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 28/03/23.
//

import Foundation

protocol PictureDetailExplorerDataServiceProtocol {
    func fetchPOD(onSuccess: @escaping (PictureOfDayModel) -> (), onError: @escaping () -> ())
    func downloadPOD(url: URL, onSuccess: @escaping (URL) -> (), onError: @escaping () -> ())
}

class PictureDetailExplorerDataService: PictureDetailExplorerDataServiceProtocol {
    
    let urlSession = URLSession.shared
    
    func fetchPOD(onSuccess: @escaping (PictureOfDayModel) -> (), onError: @escaping () -> ()) {
        guard let request = self.createPictureOfTheDayRequest() else { return }
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil || (response as? HTTPURLResponse)?.statusCode != 200, let data = data {
                    if let model = try? JSONDecoder().decode(PictureOfDayModel.self, from: data) {
                        onSuccess(model)
                        return
                    }
                }
                onError()
            }
        }
        task.resume()
    }
    
    func downloadPOD(url: URL, onSuccess: @escaping (URL) -> (), onError: @escaping () -> ()) {
        let request = URLRequest(url: url)
        let task = urlSession.downloadTask(with: request) { tempUrl, response, error in
            DispatchQueue.main.async {
                if let tempUrl = tempUrl {
                    onSuccess(tempUrl)
                } else {
                    onError()
                }
            }
        }
        task.resume()
    }
}


extension PictureDetailExplorerDataService {
    
    private func createPictureOfTheDayRequest() -> URLRequest? {
        guard var components = URLComponents(string: "https://api.nasa.gov/planetary/apod") else { return nil }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Bundle.main.getValueFromInfoPlist(ForKey: .NASAAPIKey)),
            URLQueryItem(name: "date", value: Date.getTodaysDateInAPIFriendlyFormat())
        ]
        guard let requestURL = components.url else { return nil}
        return URLRequest(url: requestURL)
    }
}
