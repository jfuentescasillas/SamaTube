//
//  PlayVideoViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//

import UIKit
import youtube_ios_player_helper


class PlayVideoViewController: UIViewController {
	// MARK: - Properties
	public var videoId: String = ""
		
	// MARK: - Elements in XIB
	@IBOutlet weak var playerView: YTPlayerView!
	@IBOutlet weak var videosTableView: UITableView!
	
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configPlayerView()
	}
	
	
	// MARK: - Private Methods
	private func configPlayerView() {
		let playerVars: [AnyHashable: Any] = ["playsinline": 1, "controls": 1, "autohide": 1, "showinfo": 0, "modestbranding": 0]
		
		playerView.load(withVideoId: videoId, playerVars: playerVars)
	}
}
