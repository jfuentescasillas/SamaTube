//
//  BaseViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	
	func configNavBar() {
		let stackOptions = UIStackView()
		stackOptions.axis = .horizontal
		stackOptions.distribution = .fillEqually
		stackOptions.spacing = 0
		stackOptions.translatesAutoresizingMaskIntoConstraints = false
		
		let share 	= buildButtons(selector: #selector(shareBtnPressed), image: .castImage, inset: 30)
		let magnify = buildButtons(selector: #selector(magnifyBtnPressed), image: .magnifyingImage, inset: 30)
		let dots 	= buildButtons(selector: #selector(dotsBtnPressed), image: .dotsImage, inset: 30)
		
		stackOptions.addArrangedSubview(share)
		stackOptions.addArrangedSubview(magnify)
		stackOptions.addArrangedSubview(dots)
		
		stackOptions.widthAnchor.constraint(equalToConstant: 120).isActive = true
		
		// Create the custom item view of the Navigation Item
		let customItemView = UIBarButtonItem(customView: stackOptions)
		customItemView.tintColor = .clear
		
		// Assignation of "customItemView" to navigationItem
		navigationItem.rightBarButtonItem = customItemView
	}
	
	
	private func buildButtons(selector: Selector, image: UIImage, inset: CGFloat) -> UIButton {
		let button = UIButton(type: .custom)
		button.addTarget(self, action: selector, for: .touchUpInside)
		button.setImage(image, for: .normal)
		button.tintColor = .whiteColor
		
		let extraPadding: CGFloat = 2.0
		button.imageEdgeInsets = UIEdgeInsets(top: inset + extraPadding,
											  left: inset,
											  bottom: inset + extraPadding,
											  right: inset)
		
		return button
	}
	
	
	// MARK: - OBJC methods
	@objc func shareBtnPressed() {
		print("Share button pressed")
	}
	
	
	@objc func magnifyBtnPressed() {
		print("Magnify button pressed")
	}
	
	
	@objc func dotsBtnPressed() {
		print("Dots button pressed")
	}
}
