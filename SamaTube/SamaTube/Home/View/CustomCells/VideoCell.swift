//
//  VideoCell.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 23/02/23.
//

import UIKit

class VideoCell: UITableViewCell {
	// MARK: - Properties
	var didTapDotsBtn: (() -> Void)?
	
	// MARK: - Elements in XIB
	@IBOutlet weak var videoImgView: UIImageView!
	@IBOutlet weak var videoTitleNameLbl: UILabel!
	@IBOutlet weak var videoChannelNameLbl: UILabel!
	@IBOutlet weak var viewsCountLbl: UILabel!
	@IBOutlet weak var dotsImgView: UIImageView!
	
	
	// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
		initialSettings()
    }

	
	// MARK: - Custom Methods
	private func initialSettings() {
		selectionStyle = .none
	}
	
	
	// MARK: - Configure Cell
	// Called from the TableView at HomeViewController
	func configCell(model: Any) {
		dotsImgView.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
		dotsImgView.tintColor = UIColor(named: "whiteColor")
		
		if let videoItem = model as? VideoItem {
			guard let imgURL = videoItem.snippet?.thumbnails?.medium?.url,
				  let url = URL(string: imgURL)
			else { return }
			
			videoImgView.kf.setImage(with: url)
			
			videoTitleNameLbl.text = videoItem.snippet?.title ?? ""
			videoChannelNameLbl.text = videoItem.snippet?.channelTitle ?? ""
			viewsCountLbl.text = "\(videoItem.statistics?.viewCount ?? "0") views - 3 months ago"
			
		} else if let playlistItems = model as? PlaylistItemsItems {
			guard let imgURL = playlistItems.snippet.thumbnails?.medium?.url,
				  let url = URL(string: imgURL) else { return }
						
			videoImgView.kf.setImage(with: url)
			
			videoTitleNameLbl.text = playlistItems.snippet.title
			videoChannelNameLbl.text = playlistItems.snippet.channelTitle
			
			viewsCountLbl.text = "456 views - 5 months ago"
		} else {
			print("ERROR. The model received is from another type: \(model)")
			print("--------------")
		}
	}
	
	
	// MARK: - Action Buttons
	@IBAction func dotsBtnPressed(_ sender: Any) {
		guard let tap = didTapDotsBtn else { return }
		
		tap()
	}
}
