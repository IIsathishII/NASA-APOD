//
//  PictureDetailExplorerViewControllerTests.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 26/03/23.
//

import XCTest
@testable import AstronomyWatch

class PictureDetailExplorerViewControllerTests: XCTestCase {
    
    var sut: PictureDetailExplorerViewController!

    override func setUpWithError() throws {
        self.sut = PictureDetailExplorerViewController()
        self.sut.loadViewIfNeeded()
        
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: self.sut)
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    func testViewDidLoad() throws {
        self.sut = PictureDetailExplorerViewController()
        let interactorMock = PictureDetailExplorerInteractorMock()
        self.sut.interactorDelegate = interactorMock
        
        self.sut.loadViewIfNeeded()
        
        XCTAssert(interactorMock.didBeginLoading, "APOD did not start loading")
    }
    
    func testSetupLoader() throws {
        self.sut.setupLoader()
        
        XCTAssert(self.sut.loader.hidesWhenStopped, "Loader doesn't hide after animating")
        XCTAssert(self.sut.loader.superview != nil, "Loader added to view hierarchy")
    }
    
    func testSetupScrollView() throws {
        self.sut.setupScrollView()
        
        XCTAssert(self.sut.scrollView.superview != nil, "Loader added to view hierarchy")
    }
    
    func testContentViewForModelWithAllData() throws {
        let interactorMock = PictureDetailExplorerInteractorMock()
        self.sut.interactorDelegate = interactorMock
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        
        self.sut.constructViewWith(Model: model)
        
        let imageView = try XCTUnwrap(self.sut.imageView, "Image view is not created")
        XCTAssert(imageView.superview != nil, "Image is not added to the view hierarchy")
        
        let titleText = try XCTUnwrap(self.sut.titleText, "Title is not created")
        XCTAssert(titleText.superview != nil, "Title is not added to the view hierarchy")
        
        let explanationText = try XCTUnwrap(self.sut.explanationText, "Explanation is not created")
        XCTAssert(explanationText.superview != nil, "Explanation is not added to the view hierarchy")
    }
    
    func testContentViewForModelWithoutImage() throws {
        let interactorMock = PictureDetailExplorerInteractorMock()
        self.sut.interactorDelegate = interactorMock
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: "About Comet ZTF",
                                      url: nil,
                                      hdUrl: nil)
        
        self.sut.constructViewWith(Model: model)
        
        XCTAssert(self.sut.imageView == nil, "Image should not be created")
        
        let titleText = try XCTUnwrap(self.sut.titleText, "Title is not created")
        XCTAssert(titleText.superview != nil, "Title is not added to the view hierarchy")
        
        let explanationText = try XCTUnwrap(self.sut.explanationText, "Explanation is not created")
        XCTAssert(explanationText.superview != nil, "Explanation is not added to the view hierarchy")
    }
    
    func testContentViewForModelWithoutTitle() throws {
        let interactorMock = PictureDetailExplorerInteractorMock()
        self.sut.interactorDelegate = interactorMock
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: nil,
                                      explanation: "About Comet ZTF",
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        
        self.sut.constructViewWith(Model: model)
        
        let imageView = try XCTUnwrap(self.sut.imageView, "Image view is not created")
        XCTAssert(imageView.superview != nil, "Image is not added to the view hierarchy")
        
        XCTAssert(self.sut.titleText == nil, "Title should not be created")
        
        let explanationText = try XCTUnwrap(self.sut.explanationText, "Explanation is not created")
        XCTAssert(explanationText.superview != nil, "Explanation is not added to the view hierarchy")
    }
    
    func testContentViewForModelWithoutExplanation() throws {
        let interactorMock = PictureDetailExplorerInteractorMock()
        self.sut.interactorDelegate = interactorMock
        
        let model = PictureOfDayModel(date: "2023-03-27",
                                      title: "Outbound Comet ZTF",
                                      explanation: nil,
                                      url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                      hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
        
        self.sut.constructViewWith(Model: model)
        
        let imageView = try XCTUnwrap(self.sut.imageView, "Image view is not created")
        XCTAssert(imageView.superview != nil, "Image is not added to the view hierarchy")
        
        let titleText = try XCTUnwrap(self.sut.titleText, "Title is not created")
        XCTAssert(titleText.superview != nil, "Title is not added to the view hierarchy")
        
        XCTAssert(self.sut.explanationText == nil, "Explanation should not be created")
    }
    
    func testShowErrorPopup() throws {
        let message = "Sample Error Message"
        self.sut.showErrorPopupWith(Message: message)
                
        let alert = try XCTUnwrap(self.sut.alertController, "Alert controller was not created")
        XCTAssert(alert.message == message, "Alert message is not displaying the given message")
        XCTAssert(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController == alert, "Alert is not presented")
    }
    
    func testShowLoader() throws {
        self.sut.showLoader(true)
        
        XCTAssert(self.sut.loader.superview != nil, "Loader is not added to the view hierarchy")
        XCTAssert(self.sut.loader.isAnimating, "Loader did not start animating")
    }
    
    func testHideLoader() throws {
        self.sut.showLoader(false)
        
        XCTAssert(self.sut.loader.superview != nil, "Loader is not added to the view hierarchy")
        XCTAssert(!self.sut.loader.isAnimating, "Loader did not stop animating")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
