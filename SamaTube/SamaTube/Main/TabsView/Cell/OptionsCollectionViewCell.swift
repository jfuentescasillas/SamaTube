//
//  OptionsCollectionViewCell.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//

import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {
	// MARK: - Properties
	override var isSelected: Bool {
		didSet {
			highlightTitle(isSelected ? .whiteColor : .grayColor)
		}
	}
	
	// MARK: - Elements in XIB
	@IBOutlet weak var tabTitleLbl: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	
	func configCell(option: String) {
		tabTitleLbl.text = option
	}
	
	
	func highlightTitle(_ color: UIColor) {
		tabTitleLbl.textColor = color
	}
}
