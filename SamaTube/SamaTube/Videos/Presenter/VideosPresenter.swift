//
//  VideosPresenter.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//


import Foundation


protocol VideosViewProtocol: AnyObject {
	func getVideos(videoList: [VideoItem])
}


class VideosPresenter {
	// MARK: - Properties
	private weak var delegate: VideosViewProtocol?
	private var provider: VideoProviderProtocol
	
	init(delegate: VideosViewProtocol, provider: VideoProviderProtocol = VideosProvider()) {
		self.delegate = delegate
		self.provider = provider
		
		#if DEBUG
		if MockManager.shared.runAppWithMock {
			self.provider = VideosProviderMock()
		}
		#endif
	}
	
	
	@MainActor
	func getVideos() async {
		do {
			let videos = try await provider.getVideos(channelID: Constants.channelID).items
			delegate?.getVideos(videoList: videos)
		} catch {
			print("Error getting the videos from VideosPresenter: \(error.localizedDescription)")
		}
	}
}
