//
//  pokemonUITests.swift
//  pokemonUITests
//
//  Created by 文 on 2024/3/29.
//

import XCTest

final class PokemonUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Setup code here.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Teardown code here.
    }

    func testNavigateToDetailPage() throws {
        app.tables.cells.containing(.staticText, identifier: "1").element.tap()
        XCTAssertTrue(app.navigationBars["pokemon.PokemonDetailView"].exists)
        XCTAssertTrue(app.staticTexts["1"].exists)
    }
    
    func testFavorite() throws {
        let button = app.tables.cells.containing(.staticText, identifier: "1").buttons["favorite"]
        let isSelected = button.isSelected
        button.tap()
        XCTAssertEqual(button.isSelected, !isSelected)
        
        app.tables.cells.containing(.staticText, identifier: "1").element.tap()
        XCTAssertTrue(app.navigationBars["pokemon.PokemonDetailView"].exists)
        XCTAssertTrue(app.staticTexts["1"].exists)
        let detailFavoriteBtn = app.buttons["favorite"]
        XCTAssertEqual(detailFavoriteBtn.isSelected, !isSelected)
        app.navigationBars["pokemon.PokemonDetailView"].buttons["Back"].tap()
        
        let switchElement = app.switches["favoriteSwitch"]
        switchElement.tap()
        XCTAssert(switchElement.value as? String == "1")
        switchElement.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                app.launch()
            }
        }
    }
}
