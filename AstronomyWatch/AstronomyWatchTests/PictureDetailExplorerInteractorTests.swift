//
//  PictureDetailExplorerInteractorTests.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 28/03/23.
//

import XCTest
@testable import AstronomyWatch

final class PictureDetailExplorerInteractorTests: XCTestCase {
    
    var sut: PictureDetailExplorerInteractor!

    override func setUpWithError() throws {
        UserDefaults.standard.pictureOfDayModel = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartLoadingWithCachedData() throws {
        self.sut = PictureDetailExplorerInteractor(dataService: PictureDetailExplorerDataServiceMock(), fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        UserDefaults.standard.pictureOfDayModel = model

        self.sut.startLoading()
        
        XCTAssert(presenterSpy.didLoadPicture, "Picture was not loaded when model was available")
    }
    
    func testStartLoadingWithRemoteFetch() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        self.sut.startLoading()
        
        XCTAssert(presenterSpy.didLoadPicture, "Loading indicator is not shown before fetch")
        XCTAssert(dataService.didPerformFetch, "Remte fetch was not performed")
    }

    func testFetchPictureOfTheDay() {
        let dataService = PictureDetailExplorerDataServiceMock()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        self.sut.fetchPictureOfTheDay()
        
        XCTAssert(presenterSpy.loadingStarted, "Loading indicator is not shown before fetch")
        XCTAssert(dataService.didPerformFetch, "Remte fetch was not performed")
    }
    
    func testFetchPictureModelDidFailWithCachedData() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        UserDefaults.standard.pictureOfDayModel = model
        
        self.sut.fetchPictureModelDidFail()
        
        XCTAssert(self.sut.fetchDidFail)
        XCTAssert(presenterSpy.didLoadPicture, "APOD not loaded when cached data was available")
        XCTAssert(presenterSpy.didHandlePODFail, "APOD failure not handled when cached data was available")
    }
    
    func testFetchPictureModelDidFailWithoutCachedData() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        self.sut.fetchPictureModelDidFail()
        
        XCTAssert(self.sut.fetchDidFail)
        XCTAssert(!presenterSpy.didLoadPicture, "APOD loaded when cached data was not available")
    }

    func testDidFetchPictureModelForValidURL() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        
        self.sut.didFetchPictureModel(model: model)
        
        XCTAssert(dataService.didPerformDownload, "File was not downloaded from given URL")
        XCTAssert(fileManager.didRemoveAllFilesFromDirectory, "Old files were not removed from the document directory")
        XCTAssert(fileManager.didCopyItem, "The downloaded file was not copied to the destination folder")
    }
    
    func testLoadPictureOfDay() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        self.sut.loadPictureOfDay(model: model)
        
        XCTAssertNotNil(UserDefaults.standard.pictureOfDayModel, "Model should have been cached")
        XCTAssert(presenterSpy.loadingEnded, "Loading indicator not hidden")
        XCTAssert(presenterSpy.didLoadPicture, "Picture not loaded")
    }
    
    func testIsValidFormat() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        
        var val = self.sut.isValidImageFormat(ext: "jpg")
        
        XCTAssert(val, "Invalid format")
        
        val = self.sut.isValidImageFormat(ext: "mov")
        
        XCTAssert(!val, "Invalid format")
    }
}
