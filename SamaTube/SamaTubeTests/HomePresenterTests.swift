//
//  HomePresenterTests.swift
//  SamaTubeTests
//
//  Created by Jorge Fuentes Casillas on 02/03/23.
//

import XCTest
@testable import SamaTube


final class HomePresenterTests: XCTestCase {
	// MARK: - Properties
	var sut: HomePresenter!
	var sutDelegate: HomeViewMock!
	var sutProvider: HomeProviderMock!

	
	// MARK: - Default Methods
    @MainActor override func setUpWithError() throws {
		MockManager.shared.runAppWithMock = true
		
		sutDelegate = HomeViewMock()
		sutProvider = HomeProviderMock()
        sut = HomePresenter(delegate: sutDelegate, provider: sutProvider)
    }

	
    override func tearDownWithError() throws {
		sutDelegate = nil
		sutProvider = nil
		sut			= nil
    }

		
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	
	// MARK: - Custom Test Methods
	func test_GetHomeObjects_WhenLoadObjectsShouldBeInCorrectPosition() async throws {
		// Act
		await sut.getHomeObjects()
		
		// Assert
		XCTAssertTrue(sutDelegate.objectList![0] is [ChannelsItem], "The received object in the 1st position is not of type ChannelsItem")
		XCTAssertTrue(sutDelegate.objectList![1] is [PlaylistItemsItem], "The received object in the 2nd position is not of type PlaylistItemsItem")
		XCTAssertTrue(sutDelegate.objectList![2] is [VideoItem], "The received object in the 3rd position is not of type VideoItem")
		XCTAssertTrue(sutDelegate.objectList![3] is [PlaylistItem], "The received object in the 4th position is not of type PlaylistItem")
	}
	
	
	func test_GetHomeObjects_WhenLoadSectionTitlesShouldBeCorrect() async throws {
		// Arrange
		let expectedSectionTitle0 = ""
		let expectedSectionTitle1 = "Victor Roldan Dev"
		let expectedSectionTitle2 = "Uploads"
		let expectedSectionTitle3 = "Created Playlists"
		
		// Act
		await sut.getHomeObjects()
		
		// Assert
		XCTAssertEqual(sutDelegate.sectionTitleList![0], expectedSectionTitle0, "The title0 is different and they should be equal")
		XCTAssertEqual(sutDelegate.sectionTitleList![1], expectedSectionTitle1, "The title1 is different and they should be equal")
		XCTAssertEqual(sutDelegate.sectionTitleList![2], expectedSectionTitle2, "The title2 is different and they should be equal")
		XCTAssertEqual(sutDelegate.sectionTitleList![3], expectedSectionTitle3, "The title3 is different and they should be equal")
	}
	
	
	@MainActor
	func test_GetHomeObjects_WhenLoadShouldFail() async throws {
		// Arrange
		MockManager.shared.runAppWithMock = false
		
		sutDelegate = HomeViewMock()
		sutProvider = HomeProviderMock()
		sutProvider.throwError = true
		sut = HomePresenter(delegate: sutDelegate, provider: sutProvider)
		
		// Act
		await sut.getHomeObjects()
		
		// Assert
		XCTAssertTrue(sutDelegate.throwError, "It works and it should fail")
	}
}



// MARK: - Class HomeViewMock
class HomeViewMock: HomeViewProtocol {
	// MAR: - Properties
	var objectList: [[Any]]?
	var sectionTitleList: [String]?
	var throwError: Bool = false
	
	
	// MARK: - Protocol Methods
	func getData(list: [[Any]], sectionTitleList: [String]) {
		objectList = list
		self.sectionTitleList = sectionTitleList
	}
	
	
	func loadingView(_ state: SamaTube.LoadingViewState) {
		
	}
	
	
	func showError(_ error: String, callback: (() -> Void)?) {
		throwError = true
	}
}
