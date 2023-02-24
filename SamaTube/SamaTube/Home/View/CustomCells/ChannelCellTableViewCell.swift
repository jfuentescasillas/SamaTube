//
//  ChannelCellTableViewCell.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 23/02/23.
//

import UIKit
import Kingfisher


class ChannelCellTableViewCell: UITableViewCell {
	// MARK: - Elements in XIB
	@IBOutlet weak var bannerImgView: UIImageView!
	@IBOutlet weak var profileImgView: UIImageView!
	@IBOutlet weak var channelTitleLbl: UILabel!
	@IBOutlet weak var subscribeLbl: UILabel!
	@IBOutlet weak var bellImgView: UIImageView!
	@IBOutlet weak var numberSubscribersLbl: UILabel!
	@IBOutlet weak var channelDescriptionLbl: UILabel!
	
	
	
	// MARK: - Life Cycle
	override func awakeFromNib() {
        super.awakeFromNib()

		initialSettings()
	}

	
	// MARK: - Custom Methods
	private func initialSettings() {
		selectionStyle = .none
		
		bellImgView.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
		bellImgView.tintColor = UIColor(named: "grayColor")
		
		profileImgView.layer.cornerRadius = 51/2
	}
	
    
	// MARK: - Configure Cell
	// Called from the TableView at HomeViewController
	func configCell(model: ChannelsItem) {
		channelTitleLbl.text = model.snippet?.title
		numberSubscribersLbl.text = "\(model.statistics?.subscriberCount ?? "0") subscribers - \(model.statistics?.videoCount ?? "0") videos"
		channelDescriptionLbl.text = model.snippet?.description
		
		// Set Banner Image
		guard let bannerUrl = model.brandingSettings?.image?.bannerExternalURL,
			  let urlBannerImg = URL(string: bannerUrl)
		else { return }
		
		bannerImgView.kf.setImage(with: urlBannerImg)
		
		// Set Profile Image
		guard let profileImgURL = model.snippet?.thumbnails?.medium?.url,
			  let urlProfileImg = URL(string: profileImgURL)
		else { return }
		
		profileImgView.kf.setImage(with: urlProfileImg)
	}
}
