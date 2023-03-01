//
//  BaseViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//


import UIKit


enum LoadingViewState {
	case show
	case hide
}


protocol BaseViewProtocol {
	func loadingView(_ state: LoadingViewState)
	func showError(_ error: String, callback: (()->Void)?)
}


class BaseViewController: UIViewController {
	// MARK: - Properties
	var loadingIndicator = UIActivityIndicatorView(style: .large)
	
	
	// MARK: - Life Cycle
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


// MARK: - Extension. Error control. Load view.
extension BaseViewController {
	func showError(_ error: String, callback: (()->Void)?) {
		let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
		
		guard let callback = callback else { return }
		
		alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
			if action.style == .default {
				callback()
				print("retry button pressed")
			}
		}))
				
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
			if action.style == .cancel {
				print("ok button pressed")
			}
		}))
		
		present(alert, animated: true)
	}
	
	
	func loadingView(_ state: LoadingViewState) {
		switch state {
		case .show:
			showLoading()
		case .hide:
			hideLoading()
		}
	}
	
	
	private func showLoading() {
		view.addSubview(loadingIndicator)
		loadingIndicator.center = view.center
		loadingIndicator.startAnimating()
	}
	
	
	private func hideLoading(){
		loadingIndicator.stopAnimating()
		loadingIndicator.removeFromSuperview()
	}
}
