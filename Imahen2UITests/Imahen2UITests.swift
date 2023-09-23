//
//  Imahen2UITests.swift
//  Imahen2UITests
//
//  Created by Marty Nodado on 9/22/23.
//

import XCTest

final class Imahen2UITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFirst() {
        let app = XCUIApplication()
        app.launch()
        
        let mainView = app.windows.element(boundBy: 0)
        mainView.tap()
        
        app.scrollViews.otherElements.buttons["Choose from Album"].tap()
        
        var exp = expectation(description: "Waiting for ImagePickerController to load")
        XCTWaiter.wait(for: [exp], timeout: 7.0)
        
        let imageChosen = app.scrollViews.otherElements.images.firstMatch
        app.scrollViews.otherElements.images.firstMatch.tap()
        
        exp = expectation(description: "Waiting for Image to load for review")
        XCTWaiter.wait(for: [exp], timeout: 5.0)
        app.buttons["Choose"].tap()
        
        exp = expectation(description: "Waiting for DraftVC to load")
        XCTWaiter.wait(for: [exp], timeout: 5.0)
        app.collectionViews.cells.element(boundBy: 0).tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
