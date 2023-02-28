//
//  TabsView.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//


import UIKit


protocol TabsViewProtocol: AnyObject {
	func didSelectOption(index: Int)
}


class TabsView: UIView {
	// MARK: - Properties
	weak private var delegate: TabsViewProtocol?
	private var options = [String]()
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	public var selectedItem: IndexPath = IndexPath(item: 0, section: 0)
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		
		let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
		collection.dataSource = self
		collection.delegate = self
		collection.translatesAutoresizingMaskIntoConstraints = false
		collection.showsVerticalScrollIndicator = false
		collection.showsHorizontalScrollIndicator = false
		collection.backgroundColor = .backgroundColor
		
		// Add inset to the left with 10 points
		collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		
		// Register cell
		collection.register(UINib(nibName: "\(OptionsCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionsCollectionViewCell.self)")
		
		return collection
	}()
	
	public var underline: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .whiteColor
		
		return view
	}()

	
	// MARK: - Required inits
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		configCollectionView()
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	
	// MARK: - Custom methods
	public func buildView(delegate: TabsViewProtocol, options: [String]) {
		self.delegate = delegate
		self.options = options
		
		collectionView.reloadData()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.configUnderline() 
		}
	}
	
	
	private func configCollectionView() {
		addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	
	private func configUnderline() {
		addSubview(underline)
		
		NSLayoutConstraint.activate([
			underline.heightAnchor.constraint(equalToConstant: 2),
			underline.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
		
		let currentCell = collectionView.cellForItem(at: selectedItem)!
		widthConstraint = underline.widthAnchor.constraint(equalToConstant: currentCell.frame.width)
		widthConstraint?.isActive = true
		
		leadingConstraint = underline.leadingAnchor.constraint(equalTo: currentCell.leadingAnchor)
		leadingConstraint?.isActive = true
	}
	
	
	// Needed to move underline when clicking on the labels of the collectionView (Home, Videos, Playlist, etc)
	public func updateUnderlinePosition(xOrigin: CGFloat, width: CGFloat) {
		widthConstraint?.constant = width
		leadingConstraint?.constant = xOrigin
		
		layoutIfNeeded()
	}
}


// MARK: - Extension. UICollectionViewDataSource
extension TabsView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return options.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OptionsCollectionViewCell.self)", for: indexPath) as? OptionsCollectionViewCell
		else {
			return UICollectionViewCell()
		}
		
		if indexPath.row == 0 {
			cell.highlightTitle(.whiteColor)
		} else {
			cell.isSelected = (selectedItem.item == indexPath.row)
		}
		
		cell.configCell(option: options[indexPath.item])
		
		return cell
	}
}


// MARK: - Extension. UICollectionViewDelegate
extension TabsView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.didSelectOption(index: indexPath.item)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}
}


// MARK: - Extension. UICollectionViewDelegateFlowLayout
extension TabsView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let label = UILabel()
		label.text = options[indexPath.item]
		label.font = UIFont.systemFont(ofSize: 16)
		
		// The extraPadding is to make the button size with a lateral margin of 10 points to the left and 10 points to the right
		let extraPadding: CGFloat = 20.0
		
		return CGSize(width: label.intrinsicContentSize.width + extraPadding,
					  height: frame.height)
	}
}
