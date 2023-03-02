//
//  HomeViewControllerTests.swift
//  SamaTubeTests
//
//  Created by Jorge Fuentes Casillas on 02/03/23.
//

import XCTest
@testable import SamaTube


final class HomeViewControllerTests: XCTestCase {
	// MARK: - Properties
	//var sut: MainViewController!
	var sut: HomeViewController!
	

	// MARK: - Default Methods
    override func setUpWithError() throws {
		/*let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(identifier: "MainViewController") as! MainViewController
		sut = vc*/
		sut = HomeViewController()
		sut.loadViewIfNeeded()
    }

	
    override func tearDownWithError() throws {
        sut = nil
    }
	
	
	// MARK: - Custom Test Methods
	func test_LoadViewController() throws {
		let tableView = try XCTUnwrap(sut.homeTableView, "-")
	}
	
	
	func test_HeaderInfoTableView_ShouldContain_ChannelInfo() throws {
		// Arrange
		let tableView = try XCTUnwrap(sut.homeTableView, "you should create this IBOutlet")
		let expLadingData = expectation(description: "loading")
		
		DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
			expLadingData.fulfill()
		}
		
		waitForExpectations(timeout: 1.0)
		
		guard let header = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChannelCellTableViewCell
		else {
			XCTFail("The first position should be the ChannelCell")
			
			return
		}
		
		let expectedTitle = "Victor Roldan Dev"
		let expectedSubscriberButton = "SUBSCRIBED"
		let subs = "383 subscribers · 43 videos"
		
		// Act
		
		// Assert
		XCTAssertEqual(expectedTitle, header.channelTitleLbl.text, "-")
		XCTAssertEqual(expectedSubscriberButton, header.subscribeLbl.text, "-")
		XCTAssertEqual(subs, header.subscriberNumbersLabel.text, "-")
	}
}
