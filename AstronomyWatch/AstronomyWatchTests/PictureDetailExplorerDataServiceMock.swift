//
//  PictureDetailExplorerDataServiceMock.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 28/03/23.
//

import Foundation
@testable import AstronomyWatch

class PictureDetailExplorerDataServiceMock: PictureDetailExplorerDataServiceProtocol {
    
    var isFetchSuccess: Bool
    var isDownloadSuccess: Bool
    
    var didPerformFetch = false
    var didPerformDownload = false
    
    init(isFetchSuccess: Bool = true, isDownloadSuccess: Bool = true) {
        self.isFetchSuccess = isFetchSuccess
        self.isDownloadSuccess = isDownloadSuccess
    }
    
    func fetchPOD(onSuccess: @escaping (PictureOfDayModel) -> (), onError: @escaping () -> ()) {
        self.didPerformFetch = true
        if self.isFetchSuccess {
            let model = PictureOfDayModel(date: Date.getTodaysDateInAPIFriendlyFormat(),
                                          title: "Outbound Comet ZTF",
                                          explanation: "About Comet ZTF",
                                          url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                          hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
            onSuccess(model)
        } else {
            onError()
        }
    }
    
    func downloadPOD(url: URL, onSuccess: @escaping (URL) -> (), onError: @escaping () -> ()) {
        self.didPerformDownload = true
        if self.isDownloadSuccess, let url = URL(string: "file:///private/var/mobile/Containers/Data/Application/CE0C7C12-D69C-4FE6-8BEE-59FF7A9CA3BF/tmp/CFNetworkDownload_dqC7u7.tmp") {
            onSuccess(url)
        } else {
            onError()
        }
    }
}
