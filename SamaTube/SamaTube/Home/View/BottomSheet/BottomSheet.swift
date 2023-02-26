//
//  BottomSheet.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 26/02/23.
//

import UIKit

class BottomSheet: UIViewController {
	// MARK: - Properties
	@IBOutlet weak var overlayView: UIView!
	@IBOutlet weak var optionsContainerView: UIView!
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay(_:)))
		overlayView.addGestureRecognizer(tapGesture)
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		optionsContainerView.animateBottomSheet(show: true) {}
	}
	
	
	// MARK: - Private methods
	@objc private func didTapOverlay(_ sender: UITapGestureRecognizer) {
		optionsContainerView.animateBottomSheet(show: false) {
			self.dismiss(animated: false)
		}
	}
}
