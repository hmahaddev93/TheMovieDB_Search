//
//  MoviewsViewControllerTests.swift
//  Movie BrowserTests
//
//  Created by Khatib Mahad H. on 7/26/21.
//

import XCTest
@testable import Movie_Browser

class MoviewsViewControllerTests: XCTestCase {

    var viewController: MoviesViewController!
    var moviesTableView: UITableView!

    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MoviesViewController
        moviesTableView = viewController.movieView.tableView
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfMoviesViewIsNotNil() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(viewController.movieView)
    }

    func testIfMoviesTableViewIsNotNil() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(moviesTableView)
    }
    
    func testIfSearchBarIsNotNil() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(viewController.movieView.searchBar)
    }

}
