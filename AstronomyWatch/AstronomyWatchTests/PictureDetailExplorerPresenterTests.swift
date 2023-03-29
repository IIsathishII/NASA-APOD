//
//  PictureDetailExplorerPresenterTests.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 27/03/23.
//

import XCTest
@testable import AstronomyWatch

class PictureDetailExplorerPresenterTests: XCTestCase {
    
    var sut: PictureDetailExplorerPresenter!
    var viewSpy: PictureDetailExplorerViewSpy!

    override func setUpWithError() throws {
        self.sut = PictureDetailExplorerPresenter(coordinator: PictureDetailExplorerCoordinator(navigationController: UINavigationController(), parent: nil))
        self.viewSpy = PictureDetailExplorerViewSpy()
        self.sut.viewDelegate = self.viewSpy
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    func testLoadPictureOfDay() throws {
        
        self.sut.loadPictureOfTheDay(model: testModel)
        
        XCTAssertNotNil(self.sut.model, "Model should be set and non-nil")
        XCTAssert(self.viewSpy.didConstructPODView, "View is not constructed for the model")
    }
    
    func testHandlePODDidFail() throws {
        self.sut.handleLoadPictureOfTheDayDidFail()
        
        XCTAssert(self.viewSpy.didShowError, "Error message not shown")
    }
    
    func testDidStartLoading() throws {
        self.sut.didStartLoading()
        
        XCTAssert(self.viewSpy.setLoaderValue, "Loader value is not set")
    }
    
    func testEndStartLoading() throws {
        self.sut.didEndLoading()
        
        XCTAssert(self.viewSpy.setLoaderValue, "Loader value is not set")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
