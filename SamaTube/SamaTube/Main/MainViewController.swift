//
//  MainViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit

class MainViewController: UIViewController {
	var rootPageViewController: RootPageViewController!
	

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? RootPageViewController {
			destination.delegateRoot = self
			rootPageViewController = destination
		}
	}
}


// MARK: - Extension. RootPageProtocol
extension MainViewController: RootPageProtocol {
	func currentPage(idx: Int) {
		print("Current page: \(idx)")
	}
}
