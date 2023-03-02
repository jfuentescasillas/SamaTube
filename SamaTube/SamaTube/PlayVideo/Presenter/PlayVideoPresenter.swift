//
//  PlayVideoPresenter.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//


import Foundation


protocol PlayVideoViewProtocol: AnyObject, BaseViewProtocol {
	func getRelatedVideosFinished()
}


@MainActor class PlayVideoPresenter {
	// MARK: - Properties
	private weak var delegate: PlayVideoViewProtocol?
	private var provider: PlayVideoProviderProtocol
		
	var relatedVideoList: [[Any]] = []
	var channelModel: ChannelsItem?
	
	init(delegate: PlayVideoViewProtocol, provider: PlayVideoProviderProtocol = PlayVideoProvider()) {
		self.delegate = delegate
		self.provider = provider
		
		#if DEBUG
		if MockManager.shared.runAppWithMock{
			self.provider = PlayVideoProviderMock()
		}
		#endif
	}
	
	
	// MARK: - Customized Methods
	public func getVideos(_ videoId: String) async {
		// Show Activity Indicator
		delegate?.loadingView(.show)
		
		do {
			// Hide Activity Indicator because data was successfully (or not) loaded
			defer {
				delegate?.loadingView(.hide)
			}
			
			let response = try await provider.getVideo(videoId)
			relatedVideoList.append(response.items)
			
			await getChannelAndRelatedVideos(videoId, response.items.first?.snippet?.channelID ?? "")

			delegate?.getRelatedVideosFinished()
		} catch {
			delegate?.showError(error.localizedDescription, callback: {
				Task { [weak self] in
					guard let self = self else { return }
					
					await self.getVideos(videoId)
				}
			})
		}
	}
	
	
	private func getChannelAndRelatedVideos(_ videoId: String, _ channelId: String) async {
		async let relatedVideos = try await provider.getRelatedVideos(videoId)
		async let channel = try await provider.getChannel(channelId)
		
		do {
			let (responseRelatedVideos, responseChannel) = await (try relatedVideos, try channel)
			let filterRelatedVideos = responseRelatedVideos.items.filter({ $0.snippet != nil })
			
			relatedVideoList.append(filterRelatedVideos)
			channelModel = responseChannel.items.first
		} catch {
			delegate?.showError(error.localizedDescription, callback: nil)
		}
	}
	
	
	func getSumNumbers(a: Int, b: Int) -> Int {
		var result = 0
		result = a + b
		
		return result
	}
}
