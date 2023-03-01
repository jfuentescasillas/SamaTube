//
//  PlayVideoViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//

import UIKit
import youtube_ios_player_helper


class PlayVideoViewController: BaseViewController {
	// MARK: - Properties
	lazy var presenter = PlayVideoPresenter(delegate: self)
	public var videoId: String = ""
	
	// Closure that returns a Bool. Read the info and send it to the other view
	public var goingToBeCollapsed: ((Bool)->Void)?
	lazy var collapseVideoButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle("", for: .normal)
		button.setImage(UIImage.chevronDown, for: .normal)
		button.tintColor = .whiteColor
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(collapsedVideoButtonPressed(_:)),
						 for: .touchUpInside)
		
		return button
	}()
	
	// MARK: - Elements in XIB
	@IBOutlet weak var playerView: YTPlayerView!
	@IBOutlet weak var videosTableView: UITableView!
	
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configPlayerView()
		configTableView()
		loadDataFromApi()
		configCloseButton()
	}
	
	
	// MARK: - Private Methods
	private func configPlayerView() {
		let playerVars: [AnyHashable: Any] = ["playsinline": 1, "controls": 1, "autohide": 1, "showinfo": 0, "modestbranding": 0]
		
		playerView.delegate = self
		playerView.load(withVideoId: videoId, playerVars: playerVars)
	}
	
	
	private func loadDataFromApi() {
		Task{ [weak self] in
			guard let self = self else { return }
			
			await self.presenter.getVideos(videoId)
		}
	}
	
	
	private func configTableView() {
		// Datasource and Delegate
		videosTableView.dataSource = self
		videosTableView.delegate = self
		
		// Register TableView
		videosTableView.register(cell: VideoHeaderCell.self)
		videosTableView.register(cell: VideoFullWidthCell.self)
		
		videosTableView.rowHeight = UITableView.automaticDimension
		videosTableView.estimatedRowHeight = 60
	}
	
	
	// MARK: - Methods to collapse VC
	@objc private func collapsedVideoButtonPressed(_ sender: UIButton) {
		guard let goingToBeCollapsed = self.goingToBeCollapsed else { return }
		goingToBeCollapsed(true)
	}
	
	
	private func configCloseButton() {
		playerView.addSubview(collapseVideoButton)
		
		NSLayoutConstraint.activate([
			collapseVideoButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 5),
			collapseVideoButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 5),
			collapseVideoButton.widthAnchor.constraint(equalToConstant: 25),
			collapseVideoButton.heightAnchor.constraint(equalToConstant: 25),
		])
	}
}


// MARK: - Extension. YTPlayerViewDelegate
extension PlayVideoViewController: YTPlayerViewDelegate {
	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
		playerView.playVideo()
	}
}


// MARK: - Extension. PlayVideoViewProtocol
extension PlayVideoViewController: PlayVideoViewProtocol {
	/*func loadingView(_ state: LoadingViewState) {
	 
	 }
	 
	 
	 func showError(_ error: String, callback: (() -> Void)?) {
	 
	 }
	 */
	
	func getRelatedVideosFinished() {
		print("***** Response in GettingVideos. Finished *****")
		videosTableView.reloadData()
	}
}


// MARK: - Extension. UITableViewDataSource
extension PlayVideoViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter.relatedVideoList.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.relatedVideoList[section].count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = presenter.relatedVideoList[indexPath.section]
		
		if indexPath.section == 0 {
			guard let video = item[indexPath.row] as? VideoItem else { return UITableViewCell() }
			
			let videoHeaderCell = tableView.dequeueReusableCell(for: VideoHeaderCell.self, for: indexPath)
			videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel!)
			videoHeaderCell.selectionStyle = .none
			
			return videoHeaderCell
			
		} else {
			guard let video = item[indexPath.row] as? VideoItem else { return UITableViewCell() }
			
			let videoFullWidthCell = tableView.dequeueReusableCell(for: VideoFullWidthCell.self, for: indexPath)
			videoFullWidthCell.configCell(model: video)
			
			return videoFullWidthCell
		}
	}
}


// MARK: - Extension. UITableViewDataSource
extension PlayVideoViewController: UITableViewDelegate {
	
}
