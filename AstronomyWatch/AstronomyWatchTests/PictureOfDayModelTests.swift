//
//  PictureOfDayModelTests.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 27/03/23.
//

import XCTest
@testable import AstronomyWatch

class PictureOfDayModelTests: XCTestCase {
    
    var data: Data!

    override func setUpWithError() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Model", withExtension: "json") else {
            XCTFail("Missing model json file")
            return
        }
        self.data = try Data(contentsOf: url)
    }

    override func tearDownWithError() throws {
        self.data = nil
    }

    func testModel() throws {
        let model = try JSONDecoder().decode(PictureOfDayModel.self, from: self.data)
        
        print(model)
        XCTAssertNotNil(model.date, "Date should not be nil")
        XCTAssertNotNil(model.title, "Title should not be nil")
        XCTAssertNotNil(model.explanation, "Explanation should not be nil")
        XCTAssertNotNil(model.url, "URL should not be nil")
        XCTAssertNotNil(model.hdurl, "HD URL should not be nil")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
