//
//  VideosViewController.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//


import UIKit


class VideosViewController: UIViewController {
	// MARK: - Properties
	lazy var presenter = VideosPresenter(delegate: self)
	private var videoList = [VideoItem]()
	
	// MARK: - Elements in XIB
	@IBOutlet weak var videosTableView: UITableView!
	
	
	// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
		
		Task {
			await presenter.getVideos()
		}
    }


	// MARK: - Private Methods
	private func configTableView() {
		videosTableView.dataSource = self
		videosTableView.delegate = self
		
		// View's Cell
		/*let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
		videosTableView.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")*/
		videosTableView.register(cell: VideoCell.self)  // This line replaces the 2 lines above
		videosTableView.separatorColor = .clear
	}
	
	
	private func configBtnSheet() {
		let vc = BottomSheet()
		vc.modalPresentationStyle = .overCurrentContext
		
		self.present(vc, animated: false)
	}
}


// MARK: - Extension. TableViewDataSource
extension VideosViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return videoList.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let video = videoList[indexPath.row]
		let cell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
		
		// The "let cell = ..." above replaces the lines of code below (guard let cell = ...). The next "guard let" statements ahead will be removed, not commented
		/*guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell
		else {
			return UITableViewCell()			
		}*/
		
		cell.didTapDotsBtn = { [weak self] in
			guard let self = self else { return }
			
			print("DotsButton tapped in videoCell")
			
			self.configBtnSheet()
		}
		cell.configCell(model: video)
		
		return cell
	}
}

	
// MARK: - Extension. TableViewDelegate
extension VideosViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 96 
	}
}
	
	
// MARK: - Extension. VideosViewProtocol
extension VideosViewController: VideosViewProtocol {
	func getVideos(videoList: [VideoItem]) {
		self.videoList = videoList
		
		videosTableView.reloadData()
	}
}
