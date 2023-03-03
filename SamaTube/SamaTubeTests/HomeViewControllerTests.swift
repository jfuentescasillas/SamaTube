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
	//var sutProvider: HomeProviderProtocol!
	var timeOut: TimeInterval = 2
	var waiting: TimeInterval = 0.2
	

	// MARK: - Default Methods
    @MainActor override func setUpWithError() throws {
		PresentMockManger.shared.vc = nil

		/*let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(identifier: "MainViewController") as! MainViewController
		sut = vc*/
		//sutProvider = HomeProviderMock()
		sut = HomeViewController()
		//sut.presenter = HomePresenter(delegate: sut, provider: sutProvider)
		sut.loadViewIfNeeded()
    }

	
    override func tearDownWithError() throws {
		PresentMockManger.shared.vc = nil

		sut = nil
    }
	
	
	// MARK: - Custom Test Methods
	func test_LoadViewController() throws {
		let tableView = try XCTUnwrap(sut.homeTableView, "-")
	}
	
	
	func test_HeaderInfoTableView_ShouldContain_ChannelInfo() throws {
		// Arrange
		let tableView = try XCTUnwrap(sut.homeTableView, "you should create this IBOutlet")
		let expLoadingData = expectation(description: "loading")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
			expLoadingData.fulfill()
		}
		
		waitForExpectations(timeout: timeOut)
		
		guard let header = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChannelCellTableViewCell
		else {
			XCTFail("The first position should be the ChannelCell")
			
			return
		}
		
		let expectedTitle = "Victor Roldan Dev"
		let expectedSubscriberButton = "SUBSCRIBED"
		let subs = "1500 subscribers - 96 videos"
		
		// Act
		
		// Assert
		XCTAssertEqual(expectedTitle, header.channelTitleLbl.text, "-")
		XCTAssertEqual(expectedSubscriberButton, header.subscribeLbl.text, "-")
		XCTAssertEqual(subs, header.numberSubscribersLbl.text, "-")
	}
	
	
	func test_VideoSection_ValidateItsContent() throws {
		//Arrange
		let tableView = try XCTUnwrap(sut.homeTableView, "you should create this IBOutlet")
		let expLadingData = expectation(description: "loading")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
			expLadingData.fulfill()
		}
		
		waitForExpectations(timeout: timeOut)
		
		guard let videoCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else {
			XCTFail("The first position should be the VideoCell")
			
			return
		}
		
		let videoName = try XCTUnwrap(videoCell.videoTitleNameLbl, "you should create this IBOutlet")
		
		XCTAssertNotNil(videoName.text)
		XCTAssertNotNil(videoCell.videoImgView)
		XCTAssertNotNil(videoCell.videoChannelNameLbl.text)
		XCTAssertNotNil(videoCell.viewsCountLbl.text)
	}
	
	
	func test_VideoSection_ValidateIfThreeDotsButton_HasAction() throws {
		//Arrange
		let tableView = try XCTUnwrap(sut.homeTableView, "you should create this IBOutlet")
		let expLadingData = expectation(description: "loading")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
			expLadingData.fulfill()
		}
		
		waitForExpectations(timeout: timeOut)
		
		guard let videoCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else {
			XCTFail("The first position should be the VideoCell")
			
			return
		}
		
		let dotsButton = try XCTUnwrap(videoCell.dotsBtnLbl)
		let dotsActions = try XCTUnwrap(dotsButton.actions(
			forTarget: videoCell,
			forControlEvent: .touchUpInside)
		)
		
		XCTAssertEqual(dotsActions.count, 1)
	}
	
	
	func test_ShareButtonPressed_ShouldPushTo_HomeViewController() throws {
		// Arrange
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let sut = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
		let navigationMock = NavigationControllerMock(rootViewController: sut)
		
		// Act
		sut.shareBtnPressed()
		
		guard let vc = navigationMock.pushedVC as? HomeViewController else {
			XCTFail("Failed. ViewController is not the HomeViewController")
			
			return
		}
		
		// Assert
		XCTAssertTrue(vc.isKind(of: HomeViewController.self))  // Not really needed since the "guard let" from above controls the situation
	}
	
	
	func test_VideoSection_OpenBottomSheet() throws {
		//Arrange
		let tableView = try XCTUnwrap(sut.homeTableView, "you should create this IBOutlet")
		let expLadingData = expectation(description: "loading")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
			expLadingData.fulfill()
		}
		
		waitForExpectations(timeout: timeOut)
		
		guard let videoCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else {
			XCTFail("The first position should be the VideoCell")
			
			return
		}
		
		let dotsButton = try XCTUnwrap(videoCell.dotsBtnLbl)
		dotsButton.sendActions(for: .touchUpInside)
		
		XCTAssertTrue(PresentMockManger.shared.vc.isKind(of: BottomSheet.self), "The type is not BottomSheet and it should be BottomSheet")
	}
}


// MARK: - Extension
extension HomeViewController {
	override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		super.present(viewControllerToPresent, animated: flag)
		
		PresentMockManger.shared.vc = viewControllerToPresent
	}
}


// MARK: - Custom Classes
class NavigationControllerMock: UINavigationController {
	var pushedVC: UIViewController!
	
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		
		pushedVC = viewController
	}
}


fileprivate class PresentMockManger {
	static var shared = PresentMockManger()
	
	init(){}
	
	var vc: UIViewController!
}
