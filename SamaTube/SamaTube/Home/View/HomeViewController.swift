//
//  HomeViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import UIKit
import FloatingPanel


class HomeViewController: BaseViewController {
	// MARK: - Properties
	lazy var presenter = HomePresenter(delegate: self)
	private var objectList = [[Any]]()
	private var sectionTitleList = [String]()
	private var fpc: FloatingPanelController?
	private var isFloatingPanelPresented: Bool = false
	
	// MARK: - Elements in storyboard
	@IBOutlet weak var homeTableView: UITableView!
	
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configTableView()
		configFloatingPanel()
		
		Task {
			await presenter.getHomeObjects()
		}
	}
	
	
	// MARK: - Private Methods
	private func configTableView() {
		// This line replaces the let nibChannel. The nibVideo, nibPlaylist and SectionTitleView will be refactored as it was done here
		homeTableView.register(cell: ChannelCellTableViewCell.self)
		/*let nibChannel = UINib(nibName: "\(ChannelCellTableViewCell.self)", bundle: nil)
		 homeTableView.register(nibChannel, forCellReuseIdentifier: "\(ChannelCellTableViewCell.self)")*/
		
		homeTableView.register(cell: VideoCell.self)
		homeTableView.register(cell: PlaylistCell.self)
		
		homeTableView.registerFromClass(headerFooterView: SectionTitleView.self)
		/*homeTableView.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")*/
		
		homeTableView.dataSource = self
		homeTableView.delegate = self
		homeTableView.separatorColor = .clear
		homeTableView.contentInset = UIEdgeInsets(top: -18, left: 0,
												  bottom: -40, right: 0)
	}
	
	
	private func configBtnSheet() {
		let vc = BottomSheet()
		vc.modalPresentationStyle = .overCurrentContext
		
		self.present(vc, animated: false)
	}
	
	
	// MARK: - Sroll view
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pan = scrollView.panGestureRecognizer
		let velocity = pan.velocity(in: scrollView).y
		
		if velocity < -5 {
			navigationController?.setNavigationBarHidden(true, animated: true)
		} else if velocity > 5 {
			navigationController?.setNavigationBarHidden(false, animated: false)
		}
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
			let channelCell = tableView.dequeueReusableCell(for: ChannelCellTableViewCell.self, for: indexPath)
			
			// The let "channelCell = ..." replaces the code below. For the other cells, the lines similar to this one will be erased and not commented such as here.
			/*guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCellTableViewCell.self)", for: indexPath) as? ChannelCellTableViewCell
			 else {
			 return UITableViewCell()
			 }*/
			
			channelCell.configCell(model: channel[indexPath.row])
			
			return channelCell
			
		} else if let playlistItems = item as? [PlaylistItemsItem] {
			let playlistItemsCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
			playlistItemsCell.didTapDotsBtn = { [weak self] in
				guard let self = self else { return }
				
				print("DotsButton tapped in playlistItems")
				
				self.configBtnSheet()
			}
			playlistItemsCell.configCell(model: playlistItems[indexPath.row])
			
			return playlistItemsCell
			
		} else if let videos = item as? [VideoItem] {
			let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
			videoCell.didTapDotsBtn = { [weak self] in
				guard let self = self else { return }
				
				print("DotsButton tapped in videoCell")
				
				self.configBtnSheet()
			}
			videoCell.configCell(model: videos[indexPath.row])
			
			return videoCell
			
		} else if let playlist = item as? [PlaylistItem] {
			let playlistCell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
			playlistCell.didTapDotsBtn = { [weak self] in
				guard let self = self else { return }
				
				print("DotsButton tapped in playlistCell")
				
				self.configBtnSheet()
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
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = objectList[indexPath.section]
		var videoID: String = ""
		
		if let playlistItem = item as? [PlaylistItemsItem] {
			videoID = playlistItem[indexPath.row].contentDetails.videoId ?? ""
			
			print("playlistItem selected with VideoID: \(videoID)")
		} else if let videos = item as? [VideoItem] {
			videoID = videos[indexPath.row].id ?? ""
			print("videos selected with VideoID: \(videoID)")
		} else {
			print("Invalid Video Selected with id: \(videoID)")
			print("*********************")
		}
		
		/* This if-else statement solve the next crash:
		 1. Select a video
		 2. Minimize (but don't close) the playing video
		 3. Click on another video on the tableView
		 */
		if isFloatingPanelPresented {
			guard let fpc = fpc else { return }
			
			fpc.willMove(toParent: nil)
			fpc.hide(animated: true) { [weak self] in
				guard let self = self else { return }
				
				// Remove floating panel view from controller's view
				fpc.view.removeFromSuperview()
				
				// Remove floating panel controller from controller hierarchy
				fpc.removeFromParent()
				
				self.dismiss(animated: true) {
					self.presentViewPanel(with: videoID)
				}
			}
		} else {
			print("-----------FALSE-----------")
			presentViewPanel(with: videoID)
		}
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


// MARK: - Extension. FloatingPanelDelegate
extension HomeViewController: FloatingPanelControllerDelegate {
	// Private Methods
	private func configFloatingPanel() {
		fpc = FloatingPanelController(delegate: self)
		fpc?.isRemovalInteractionEnabled = true
		fpc?.surfaceView.grabberHandle.isHidden = true
		fpc?.layout = MyFloatingPanelLayout()
		fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
	}
	
	
	private func presentViewPanel(with videoId: String) {
		let contentVC = PlayVideoViewController()
		contentVC.videoId = videoId
		
		// Receives the action sent from the contentVC (in this case: PlayVideoViewController()
		contentVC.goingToBeCollapsed = { [weak self] isGoingToBeCollapsed in
			guard let self = self else { return }
			
			if isGoingToBeCollapsed {
				self.fpc?.move(to: .tip, animated: true)
				
				NotificationCenter.default.post(name: .viewPosition, object: ["position":"bottom"])
				self.fpc?.surfaceView.contentPadding = .init(top: 0, left: 0, bottom: 0, right: 0)
			} else {
				self.fpc?.move(to: .full, animated: true)
				
				NotificationCenter.default.post(name: .viewPosition, object: ["position":"top"])
				self.fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
			}
		}
		
		guard let fpc = fpc else { return }
		
		isFloatingPanelPresented = true
		
		fpc.set(contentViewController: contentVC)
		fpc.track(scrollView: contentVC.tableViewVideos)
		
		present(fpc, animated: true)
	}
	
	
	// FloatingPanelControllerDelegate Methods
	func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
		
	}
	
	
	func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
		if targetState.pointee != .full {
			NotificationCenter.default.post(name: .viewPosition, object: ["position":"bottom"])
			fpc?.surfaceView.contentPadding = .init(top: 0, left: 0, bottom: 0, right: 0)
		} else {
			NotificationCenter.default.post(name: .viewPosition, object: ["position":"top"])
			fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
		}
	}
}


// MARK: - FPC Class
class MyFloatingPanelLayout: FloatingPanelLayout {
	let position: FloatingPanelPosition = .bottom
	let initialState: FloatingPanelState = .full
	var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
		return [
			.full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
			.tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
		]
	}
}


// MARK: - NSNotification
extension NSNotification.Name{
	static let viewPosition = Notification.Name("viewPosition")
	static let expand = Notification.Name("expand")
}
