//
//  HomeViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit


class HomeViewController: UIViewController {
	// MARK: - Properties
	lazy var presenter = HomePresenter(delegate: self)
	private var objectList = [[Any]]()
	private var sectionTitleList = [String]()
	
	// MARK: - Elements in storyboard
	@IBOutlet weak var homeTableView: UITableView!
	
	
	// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

		configTableView()
				
		Task {
			await presenter.getHomeObjects()
		}
    }
	
	
	private func configTableView() {
		let nibChannel = UINib(nibName: "\(ChannelCellTableViewCell.self)", bundle: nil)
		homeTableView.register(nibChannel, forCellReuseIdentifier: "\(ChannelCellTableViewCell.self)")
		
		let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
		homeTableView.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
		
		let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
		homeTableView.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
		
		homeTableView.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
		
		homeTableView.dataSource = self
		homeTableView.delegate = self
		homeTableView.separatorColor = .clear
	}
}


// MARK: - Extension. UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return objectList.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objectList[section].count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = objectList[indexPath.section]
		
		if let channel = item as? [ChannelsItem] {
			guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCellTableViewCell.self)", for: indexPath) as? ChannelCellTableViewCell
			else {
				return UITableViewCell()
			}
			
			channelCell.configCell(model: channel[indexPath.row])
			
			return channelCell
			
		} else if let playlistItems = item as? [PlaylistItemsItems] {
			guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell
			else {
				return UITableViewCell()
			}
			
			playlistItemsCell.configCell(model: playlistItems[indexPath.row])
			
			return playlistItemsCell
			
		} else if let videos = item as? [VideoItem] {
			guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell
			else {
				return UITableViewCell()
			}
			
			videoCell.configCell(model: videos[indexPath.row])
			
			return videoCell
			
		} else if let playlist = item as? [PlaylistItem] {
			guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell
			else {
				return UITableViewCell()
			}
			
			playlistCell.configCell(model: playlist[indexPath.row])
			
			return playlistCell
			
		} else {
			return UITableViewCell()
		}
	}
}


// MARK: - Extension. UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch  indexPath.section {
		case 0, 3:
			return UITableView.automaticDimension
			
		default:
			return 95
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView
		else { return nil }
		
		sectionView.title.text = sectionTitleList[section]
		sectionView.configView()
		
		return sectionView
	}
}


// MARK: - Extension. HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
	func getData(list: [[Any]], sectionTitleList: [String]) {
		objectList = list
		self.sectionTitleList = sectionTitleList
		
		homeTableView.reloadData()
	}
}
