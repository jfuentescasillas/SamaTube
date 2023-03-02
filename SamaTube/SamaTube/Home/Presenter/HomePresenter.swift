//
//  HomePresenter.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 19/02/23.
//


import Foundation


// MARK: - HomeViewProtocol
// It will be called from an extension in HomeViewController
protocol HomeViewProtocol: AnyObject, BaseViewProtocol {
	func getData(list: [[Any]], sectionTitleList: [String])
}


// MARK: - HomePresenter
@MainActor class HomePresenter {
	var provider: HomeProviderProtocol
	weak var delegate: HomeViewProtocol?
	private var objectList = [[Any]]()
	private var sectionTitlelist = [String]()
	
	init(delegate: HomeViewProtocol, provider: HomeProviderProtocol = HomeProvider()) {
		self.delegate = delegate
		self.provider = provider
		
		#if DEBUG
		if MockManager.shared.runAppWithMock {
			self.provider = HomeProviderMock()
		}
		#endif
	} 
	
	
	@MainActor
	func getHomeObjects() async {
		objectList.removeAll()
		sectionTitlelist.removeAll()
		
		// Show Activity Indicator
		delegate?.loadingView(.show)
		
		// Ready to be called
		async let channels = try await provider.getChannel(channelID: Constants.channelID).items
		async let playlist = try await provider.getPlaylists(channelID: Constants.channelID).items
		async let videos   = try await provider.getVideos(searchString: "", channelID: Constants.channelID).items
		
		do {
			// Hide Activity Indicator because data was successfully (or not) loaded
			defer {
				delegate?.loadingView(.hide)
			}
			
			let (resChannels, resPlaylist, resVideos) = await (try channels, try playlist, try videos)
			// Index 0
			objectList.append(resChannels)
			sectionTitlelist.append("") // No need of title
			
			// Index 1
			if let playListID = resPlaylist.first?.itemId,
			   let playlistItems = await getPlaylistItems(playlistID: playListID) {
				objectList.append(playlistItems.items.filter({ $0.snippet.title != "Private video" }))
				sectionTitlelist.append(resPlaylist.first?.snippet.channelTitle ?? "")
			}
			
			// Index 2
			objectList.append(resVideos)
			sectionTitlelist.append("Uploads")
			
			// Index 3
			objectList.append(resPlaylist)
			sectionTitlelist.append("Created Playlists")
			
			// Delegate
			delegate?.getData(list: objectList, sectionTitleList: sectionTitlelist)
		} catch let error {
			delegate?.showError(error.localizedDescription, callback: {
				Task { [weak self] in
					guard let self = self else { return }
					
					await self.getHomeObjects()
				}
			})
			
			
		}
	}
	
	
	func getPlaylistItems(playlistID: String) async -> PlaylistItemsModel? {
		do {
			let playlistItems = try await provider.getPlaylistItems(playlistId: playlistID)
			
			return playlistItems
		} catch {
			delegate?.showError(error.localizedDescription, callback: {
				Task { [weak self] in
					guard let self = self else { return }
					
					await self.getHomeObjects()
				}
			})

			return nil
		}
	}
}
