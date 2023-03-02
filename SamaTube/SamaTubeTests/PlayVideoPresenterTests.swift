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
	var timeOut: TimeInterval = 20.0
	
	
	// MARK: - Default Methods
	@MainActor override func setUpWithError() throws {
		MockManager.shared.runAppWithMock = true
		
		sutDelegate = PlayVideoViewMock()
		sutProviderMock = PlayVideoProviderMock()
		
		sut = PlayVideoPresenter(delegate: sutDelegate, provider: sutProviderMock)
	}
	
	
	@MainActor override func tearDownWithError() throws {
		sutDelegate		= nil
		sutProviderMock = nil
		sut 			= nil
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
		sutDelegate.expectGetRelatedVideosFinished = expectation(description: "loading video")
		sutDelegate.expectLoading = expectation(description: "show/hide loading")
		sutDelegate.expectLoading?.expectedFulfillmentCount = 2
		
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
		XCTAssertTrue(sut.channelModel!.id == Constants.channelID, "Expected ID should be (\(Constants.channelID)) but it was received (\(String(describing: sut.channelModel!.id)))")
		
		XCTAssertTrue(sutDelegate.loadingViewWasCalled)
		XCTAssertTrue(sutDelegate.loadingShow, "Loading should show")
		XCTAssertTrue(sutDelegate.loadingHide, "Loading should hide")
	}
	
	
	func test_GetVideos_ShouldFailWithoutAsync() {
		MockManager.shared.runAppWithMock = false
		
		sutDelegate = PlayVideoViewMock()
		sutDelegate.expectShowError = expectation(description: "loading")
		sutProviderMock = PlayVideoProviderMock()
		sutProviderMock.throwError = true
		
		sut = PlayVideoPresenter(delegate: sutDelegate, provider: sutProviderMock)
		
		Task {
			await sut.getVideos(videoID)
		}
		
		
		waitForExpectations(timeout: timeOut)
		
		XCTAssertFalse(sutDelegate.getRelatedVideosFinishedWasCalled, "It should be false but it's true")
		XCTAssertTrue(sutDelegate.showErrorWasCalled, "It should fail but it is working fine")
	}
	
	
	func test_GetChannelAndRelatedVideos_ShouldFail() {
		MockManager.shared.runAppWithMock = false
		
		sutDelegate = PlayVideoViewMock()
		sutDelegate.expectShowError = expectation(description: "loading")
		sutProviderMock = PlayVideoProviderMock()
		sutProviderMock.throwError = true
		
		sut = PlayVideoPresenter(delegate: sutDelegate, provider: sutProviderMock)
		
		Task {
			await sut.getChannelAndRelatedVideos(videoID, Constants.channelID)
		}
		
		
		waitForExpectations(timeout: timeOut)
		
		XCTAssertTrue(sutDelegate.showErrorWasCalled, "It should fail but it is working fine")
	}
}


// MARK: - Class. PlayVideoViewMock
// It works as a delegateMock
class PlayVideoViewMock: PlayVideoViewProtocol {
	// MARK: - Properties
	var loadingViewWasCalled: Bool = false
	var getRelatedVideosFinishedWasCalled: Bool = false
	var expectGetRelatedVideosFinished: XCTestExpectation?
	var expectLoading: XCTestExpectation?
	var expectShowError: XCTestExpectation?
	var showErrorWasCalled: Bool = false
	var loadingShow: Bool = false
	var loadingHide: Bool = false
	
	
	// MARK: - Protocol Methods
	func loadingView(_ state: SamaTube.LoadingViewState) {
		if state == .show {
			loadingShow = true
		} else if state == .hide {
			loadingHide = true
		}
		
		loadingViewWasCalled = true
		expectLoading?.fulfill()
	}
	
	
	func showError(_ error: String, callback: (() -> Void)?) {
		showErrorWasCalled = true
		expectShowError?.fulfill()
	}
	
	
	func getRelatedVideosFinished() {
		getRelatedVideosFinishedWasCalled = true
		expectGetRelatedVideosFinished?.fulfill()
	}
}

