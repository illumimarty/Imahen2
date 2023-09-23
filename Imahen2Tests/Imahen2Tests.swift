//
//  Imahen2Tests.swift
//  Imahen2Tests
//
//  Created by Marty Nodado on 9/22/23.
//

import XCTest

final class Imahen2Tests: XCTestCase {
    
    let app = XCUIApplication()
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirst() {
        // 1. Tap anywhere on the screen
        let mainView = app.windows.element(boundBy: 0)
        mainView.tap()
        
        // 2. Tap on Choose Album
        let chooseAlbumOption = app.alerts.buttons["Choose from Album"]
        XCTAssertTrue(chooseAlbumOption.exists, "Choose from Album button not found")
        chooseAlbumOption.tap()
        
        
        // 3. Choose photo
//        let photosApp = app.ap
    }
    
    func testNavigationToFilterLevel() {
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
