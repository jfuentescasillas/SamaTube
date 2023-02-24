//
//  PlaylistCell.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 23/02/23.
//


import UIKit
import Kingfisher


class PlaylistCell: UITableViewCell {
	// MARK: - Elements in XIB
	@IBOutlet weak var videoImgView: UIImageView!
	@IBOutlet weak var videoTitleLbl: UILabel!
	@IBOutlet weak var videoCountLbl: UILabel!
	
	@IBOutlet weak var videoCountOverlay: UILabel!
	@IBOutlet weak var dotsImgView: UIImageView!
	
	
	// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
		
		initialSettings()
    }

	
	// MARK: - Custom Methods
	private func initialSettings() {
		selectionStyle = .none
		
		dotsImgView.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
		dotsImgView.tintColor = UIColor(named: "whiteColor")
	}
	
    
	// MARK: - Configure Cell
	// Called from the TableView at HomeViewController
	func configCell(model: PlaylistItem) {
		let imgURL = model.snippet.thumbnails.medium.defaultUrl
		
		guard let url = URL(string: imgURL) else { return }
		
		videoImgView.kf.setImage(with: url)
		
		videoTitleLbl.text = model.snippet.title
		videoCountLbl.text = "\(model.contentDetails.itemCount) videos"
		videoCountOverlay.text = "\(model.contentDetails.itemCount)"
	}
}
