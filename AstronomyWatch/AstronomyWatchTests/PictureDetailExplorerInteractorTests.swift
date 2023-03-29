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
                
        UserDefaults.standard.pictureOfDayModel = testModel

        self.sut.startLoading()
        
        XCTAssert(presenterSpy.didLoadPicture, "Picture was not loaded when model was available")
    }
    
    func testStartLoadingWithRemoteFetch() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: AWFileManagerSpy())
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        self.sut.startLoading()
        
        XCTAssert(presenterSpy.loadingStarted, "Loading indicator is not shown before fetch")
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
                
        UserDefaults.standard.pictureOfDayModel = testModel
        
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
        
        self.sut.didFetchPictureModel(model: testModel)
        
        XCTAssert(dataService.didPerformDownload, "File was not downloaded from given URL")
    }
    
    func testPerformFileDownloadSuccess() throws {
        let dataService = PictureDetailExplorerDataServiceMock(isDownloadSuccess: true)
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let url = try XCTUnwrap(testModel.url, "URL is not available")
                
        let expectation = expectation(description: "Wait for file to download")
        var didSucceed = false
        self.sut.performFileDownload(url: url) { url in
            didSucceed = true
            expectation.fulfill()
        } onError: {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssert(didSucceed, "File download call failed")
    }
    
    func testPerformFileDownloadFail() throws {
        let dataService = PictureDetailExplorerDataServiceMock(isDownloadSuccess: false)
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let url = try XCTUnwrap(testModel.url, "URL is not available")
                
        let expectation = expectation(description: "Wait for file to download")
        var didFail = false
        self.sut.performFileDownload(url: url) { url in
            expectation.fulfill()
        } onError: {
            didFail = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssert(didFail, "File download call succeeded")
    }
    
    func testHandleDownloadedFile() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        let url = try XCTUnwrap(testModel.url, "URL is not available")
        self.sut.handleDownloadedFile(remoteURL: url, tempURL: URL(fileURLWithPath: "file://dummy"))
        
        XCTAssert(fileManager.didRemoveAllFilesFromDirectory, "Old files were not removed from the document directory")
        XCTAssert(fileManager.didCopyItem, "The downloaded file was not copied to the destination folder")
    }
    
    func testLoadPictureOfDay() throws {
        let dataService = PictureDetailExplorerDataServiceMock()
        let fileManager = AWFileManagerSpy()
        self.sut = PictureDetailExplorerInteractor(dataService: dataService, fileManager: fileManager)
        let presenterSpy = PictureDetailExplorerPresenterSpy()
        self.sut.presenterDelegate = presenterSpy
        
        self.sut.loadPictureOfDay(model: testModel)
        
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
