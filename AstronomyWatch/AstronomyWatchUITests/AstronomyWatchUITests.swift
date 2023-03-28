//
//  AstronomyWatchUITests.swift
//  AstronomyWatchUITests
//
//  Created by Sathish Kumar S on 25/03/23.
//

import XCTest
import AstronomyWatch

class AstronomyWatchUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        try self.removeFilesFromDocumentDirectory()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAstronomyPictureOfDayRemoteFetch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["Testing"]
        app.launch()

        let doesNotExistPredicate = NSPredicate(format: "exists == FALSE")
        let loader = app.activityIndicators["loaderIndicator"]
        self.expectation(for: doesNotExistPredicate, evaluatedWith: loader)
        self.waitForExpectations(timeout: 15)
        
        XCTAssert(app.staticTexts["apodTitle"].exists, "APOD Title is not available")
        XCTAssert(app.staticTexts["apodExplanation"].exists, "APOD Title is not available")
    }
    
    func testAstronomyPictureOfTheDayCached() throws {
        let app = XCUIApplication()
        app.launchArguments = ["Testing", "Cached"]
        app.launch()

        XCTAssert(app.images["apodImage"].exists, "APOD Image is not available")
        XCTAssert(app.staticTexts["apodTitle"].exists, "APOD Title is not available")
        XCTAssert(app.staticTexts["apodExplanation"].exists, "APOD Title is not available")
    }
}

extension AstronomyWatchUITests {
    
    func removeFilesFromDocumentDirectory() throws {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let files = try? FileManager.default.contentsOfDirectory(atPath: documentDirectory.path) {
            for file in files {
                let filePath = documentDirectory.appendingPathComponent(file)
                try FileManager.default.removeItem(at: filePath)
            }
        }
    }
}
