//
//  MovieFlixUITests.swift
//  MovieFlixUITests
//
//  Created by Sujal on 24/11/2025.
//

import XCTest

final class MovieFlixUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSearchUIExists() {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
        navBar.tap()
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
    }
    
    func testSearchForMovie() {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
        navBar.tap()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        
        searchField.tap()
        searchField.typeText("Inception\n")
        
        let firstCell = app.cells.containing(.staticText, identifier: "Inception").firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
    }
    
    func testNavigateToMovieDetails() {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
        navBar.tap()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        
        searchField.tap()
        searchField.typeText("Inception\n")
        
        let firstCell = app.cells.containing(.staticText, identifier: "Inception").firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let titleLabel = app.staticTexts["movieTitleLabel"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5))
    }
   
    func testFavoriteButtonToggle() {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
        navBar.tap()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        
        searchField.tap()
        searchField.typeText("Inception\n")
        
        let firstCell = app.cells.containing(.staticText, identifier: "Inception").firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let favoriteButton = app.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        
        favoriteButton.tap()
        favoriteButton.tap()
    }
    
    func testFavoritesButtonDisplays() {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
        
        let favoritesButton = navBar.buttons["heart"]
        XCTAssertTrue(favoritesButton.exists)
        
        favoritesButton.tap()
        
        let emptyLabel = app.staticTexts["favoritesPage"]
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: 3))
    }
}
