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
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                onSuccess(testModel)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                onError()
            }
        }
    }
    
    func downloadPOD(url: URL, onSuccess: @escaping (URL) -> (), onError: @escaping () -> ()) {
        self.didPerformDownload = true
        if self.isDownloadSuccess, let url = URL(string: "file:///private/var/mobile/Containers/Data/Application/CE0C7C12-D69C-4FE6-8BEE-59FF7A9CA3BF/tmp/CFNetworkDownload_dqC7u7.tmp") {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                onSuccess(url)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                onError()
            }
        }
    }
}
