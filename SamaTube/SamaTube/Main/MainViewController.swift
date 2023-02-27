//
//  MainViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit

class MainViewController: BaseViewController {
	var rootPageViewController: RootPageViewController!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		configNavBar()
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
extension MainViewController: RootPageProtocol {
	func currentPage(idx: Int) {
		print("Current page: \(idx)")
	}
}
