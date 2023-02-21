//
//  RootPageViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit


// It's AnyObject because the variable "delegateRoot" will be declared as weak
protocol RootPageProtocol: AnyObject {
	func currentPage(idx: Int)
}


// MARK: - Main class. RootPageViewController
class RootPageViewController: UIPageViewController {
	var subViewControllers = [UIViewController]()
	var currentIdx: Int = 0
	weak var delegateRoot: RootPageProtocol?
	

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		delegate = self
		dataSource = self
		
		setupViewControllers()
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
