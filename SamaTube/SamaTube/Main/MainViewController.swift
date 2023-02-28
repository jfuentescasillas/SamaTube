//
//  MainViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit

class MainViewController: BaseViewController {
	// MARK: - Properties
	public var rootPageViewController: RootPageViewController!
	private var options: [String] = ["HOME", "VIDEOS", "PLAYLIST", "CHANNEL", "ABOUT"]
	private var prevPercent: CGFloat = 0
	private var currentPageIdx: Int = 0 {
		willSet {
			print("WillSet: \(currentPageIdx)")
			
			let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIdx, section: 0))
			cell?.isSelected = false
		}
		
		didSet {
			print("didSet: \(currentPageIdx)")
			
			if let _ = rootPageViewController {
				rootPageViewController.currentPage = currentPageIdx
				
				let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIdx, section: 0))
				cell?.isSelected = true
			}
		}
	}
	public var didTapOption: Bool = false {
		didSet {
			if didTapOption {
				tabsView.isUserInteractionEnabled = false
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
					self.didTapOption.toggle()
					self.tabsView.isUserInteractionEnabled = true
				}
			}
		}
	}
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var tabsView: TabsView!
	
	
	// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configNavBar()
		tabsView.buildView(delegate: self, options: options)
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? RootPageViewController {
			destination.delegateRoot = self
			rootPageViewController = destination
		}
	}
	
	
	// MARK: - Override BaseViewController Methods
	override func dotsBtnPressed() {
		super.dotsBtnPressed()
		print("DotsBtnPressed but it was overriden")
	}
}


// MARK: - Extension. RootPageProtocol
// Change the view by scrolling
extension MainViewController: RootPageProtocol {
	func currentPage(idx: Int) {
		print("Current page (scrolling): \(idx)")
		print("----------------------")
		currentPageIdx = idx
		tabsView.selectedItem = IndexPath(item: idx, section: 0)
	}
	
	
	func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int) {
		if percent == 0.0 || didTapOption {
			return
		}
		
		let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
		
		if direction == .goingRight {
			// ---->> [View goes to the right using scroll]
			if index == options.count-1 {
				return
			}
			
			// The next index would be the current +1
			let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index+1,
																			 section: 0))
			// Add the accumulated + the % scrolled of the current cell
			let calculatedNewLeading = currentCell!.frame.origin.x + (currentCell!.frame.width * percent)
			let newWidth = (prevPercent < percent) ? nextCell?.frame.width : currentCell?.frame.width
			
			// Update variables with the constraints
			updateUnderlineConstraints(calculatedNewLeading, newWidth!)
		} else { // <<---- [View goes to the left using scroll]
			// If on the 1st page, and tries to move to the right, returns
			if index == 0 {
				return
			}
			
			// The next index would be the current one - 1
			let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index-1, section: 0))
			
			// Adds the accumulated + the % of the scrolling of the current cell
			let calculateNewLeading = currentCell!.frame.origin.x - (currentCell!.frame.width * percent)
			let newWidth = (prevPercent < percent) ? nextCell?.frame.width : currentCell?.frame.width
			
			// Update the variables with the constraints
			updateUnderlineConstraints(calculateNewLeading, newWidth!)
		}
		
		// Save the prevPercent to know if it goes to the right or to the left inside the same page
		prevPercent = percent
	}
	
	
	private func updateUnderlineConstraints(_ leading: CGFloat, _ width: CGFloat) {
		tabsView.leadingConstraint?.constant = leading
		tabsView.widthConstraint?.constant = width
		tabsView.layoutIfNeeded()
	}
}


// MARK: - Extension. TabsViewProtocol
// Change the view by clicking
extension MainViewController: TabsViewProtocol {
	func didSelectOption(index: Int) {
		print("Index of selected option (click made): \(index)")
		print("----------------------")
		
		didTapOption = true
		
		// Update position of underline when clicked on that option
		let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))!
		tabsView.updateUnderlinePosition(xOrigin: currentCell.frame.origin.x,
										 width: currentCell.frame.width)
		
		var direction: UIPageViewController.NavigationDirection = .forward
		
		// This if statement helps with the animation from left to right and vice versa
		if index < currentPageIdx {
			direction = .reverse
		}
		
		rootPageViewController.setviewControllerFromIndex(idx: index, direction: direction)
		 
		currentPageIdx = index
	}
}
