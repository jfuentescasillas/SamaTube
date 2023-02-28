//
//  RootPageViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//


import UIKit


enum ScrollDirection {
	case goingLeft
	case goingRight
}


// It's AnyObject because the variable "delegateRoot" will be declared as weak
protocol RootPageProtocol: AnyObject {
	func currentPage(idx: Int)
	func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int)
}


// MARK: - Main class. RootPageViewController
class RootPageViewController: UIPageViewController {
	weak var delegateRoot: RootPageProtocol?
	public var subViewControllers = [UIViewController]()
	public var currentIdx: Int = 0
	public var startOffset: CGFloat = 0
	public var currentPage: Int = 0
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
		dataSource = self
		
		delegateRoot?.currentPage(idx: 0)
		setupViewControllers()
		setScrollViewDelegate()
	}
	
	
	// MARK: - Setup viewControllers
	private func setupViewControllers() {
		subViewControllers = [
			HomeViewController(),
			VideosViewController(),
			PlaylistsViewController(),
			ChannelsViewController(),
			AboutViewController()
		]
		
		// Assign an ID to each controller
		_ = subViewControllers.enumerated().map({$0.element.view.tag = $0.offset })
		
		setviewControllerFromIndex(idx: 0, direction: .forward)
	}
	
	
	public func setviewControllerFromIndex(idx: Int, direction: NavigationDirection, animated: Bool = true) {
		setViewControllers([subViewControllers[idx]], direction: direction, animated: animated)
	}
	
	
	// Needed to move underline when scrolling between views
	public func setScrollViewDelegate() {
		guard let scrollView = view.subviews.filter({ $0 is UIScrollView }).first as? UIScrollView
		else { return }
		
		scrollView.delegate = self
	}
}


// MARK: - Extension. UIPageViewControllerDataSource
extension RootPageViewController: UIPageViewControllerDataSource {
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return subViewControllers.count
	}
	
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let idx: Int = subViewControllers.firstIndex(of: viewController) ?? 0
		
		if idx <= 0 {
			return nil
		} else {
			return subViewControllers[idx-1]
		}
	}
	
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let idx: Int = subViewControllers.firstIndex(of: viewController) ?? 0
		
		if idx >= (subViewControllers.count - 1) {
			return nil
		} else {
			return subViewControllers[idx+1]
		}
	}
}


// MARK: - Extension. UIPageViewControllerDelegate
extension RootPageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if let idx = pageViewController.viewControllers?.first?.view.tag {
			currentIdx = idx
			delegateRoot?.currentPage(idx: idx)
		}
		
		print("Finished: \(finished)")
	}
}


// MARK: - Extension. UIScrollViewDelegate
extension RootPageViewController: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		startOffset = scrollView.contentOffset.x
		print("Start Offset: \(startOffset)")
	}
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		var direction = 0 // Scroll stopped
		
		if startOffset < scrollView.contentOffset.x {
			direction = 1 // To the right
		} else if startOffset > scrollView.contentOffset.x {
			direction = -1 // To the left
		}
		
		let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
		let percent = positionFromStartOfCurrentPage / self.view.frame.width
		
		delegateRoot?.scrollDetails(direction: (direction == 1) ? .goingRight : .goingLeft, percent: percent, index: currentPage)
		
		print("Percent: \(percent)")
		print("Direction: \(direction)")
	}
}
