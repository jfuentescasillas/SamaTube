//
//  PlayVideoPresenterTests.swift
//  SamaTubeTests
//
//  Created by Jorge Fuentes Casillas on 02/03/23.
//


import XCTest
@testable import SamaTube


@MainActor
final class PlayVideoPresenterTests: XCTestCase {
	// MARK: - Properties
	var sut: PlayVideoPresenter!  // System Under Test
	var sutDelegate: PlayVideoViewMock!
	var sutProviderMock: PlayVideoProviderMock!
	var videoID: String = "eLhG15kJws0"
	var timeOut: TimeInterval = 2.0
	
	
	// MARK: - Default Methods
	@MainActor override func setUpWithError() throws {
		sutDelegate = PlayVideoViewMock()
		sutProviderMock = PlayVideoProviderMock()
		
		sut = PlayVideoPresenter(delegate: sutDelegate, provider: sutProviderMock)
	}
	
	
	@MainActor override func tearDownWithError() throws {
		sutDelegate		= nil
		sutProviderMock = nil
		sut 			= nil
	}
	
	
	
	func testExample() throws {
		
	}
	
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
	
	// MARK: - Methods to Test
	func test_GetSumNumbers() {
		let expectedResult = 12
		let calculatedResult = sut.getSumNumbers(a: 3, b: 9)
		
		XCTAssertTrue(calculatedResult == expectedResult, "The expected result is \(expectedResult) but the calculated result was \(calculatedResult)")
	}
	
	
	func test_GetVideos() async {
		await sut.getVideos(videoID)
		
		// Check the videoList is not empty
		XCTAssertTrue(sut.relatedVideoList.isEmpty == false)
	}
	
	
	func test_GetVideosWithoutAsync() {
		sutDelegate.expectationGetRelatedVideosFinished = expectation(description: "loading video")
		
		Task {
			await sut.getVideos(videoID)
		}
		
		waitForExpectations(timeout: timeOut)
		
		// Assertions
		guard let videos = sut.relatedVideoList.first as? [VideoItem] else {
			XCTFail("Error. The desired object does not exist at the 1st position.")
			
			return
		}
		
		XCTAssertTrue(videos.first?.id == videoID, "Received ID (\(String(describing: videos.first?.id))) is different from expected ID (\(videoID))")
		XCTAssertTrue(sut.relatedVideoList.count == 2)
	}
}


// MARK: - Class. PlayVideoViewMock
// It works as a delegateMock
class PlayVideoViewMock: PlayVideoViewProtocol {
	// MARK: - Properties
	var loadingViewWasCalled: Bool = false
	var showErrorWasCalled: Bool = false
	var getRelatedVideosFinishedWasCalled: Bool = false
	var expectationGetRelatedVideosFinished: XCTestExpectation?
	
	
	// MARK: - Protocol Methods
	func loadingView(_ state: SamaTube.LoadingViewState) {
		loadingViewWasCalled = true
	}
	
	
	func showError(_ error: String, callback: (() -> Void)?) {
		showErrorWasCalled = true
	}
	
	
	func getRelatedVideosFinished() {
		getRelatedVideosFinishedWasCalled = true
		expectationGetRelatedVideosFinished?.fulfill()
	}
}

