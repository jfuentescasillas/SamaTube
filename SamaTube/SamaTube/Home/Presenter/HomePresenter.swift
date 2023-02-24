//
//  HomePresenter.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 19/02/23.
//


import Foundation


protocol HomeViewProtocol: AnyObject {
	func getData(list: [[Any]], sectionTitleList: [String])
}


class HomePresenter {
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
		
		// Ready to be called
		async let channels = try await provider.getChannel(channelID: Constants.channelID).items
		async let playlist = try await provider.getPlaylists(channelID: Constants.channelID).items
		async let videos   = try await provider.getVideos(searchString: "", channelID: Constants.channelID).items
		
		do {
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
		} catch {
			print(error)
		}
	}
	
	
	func getPlaylistItems(playlistID: String) async -> PlaylistItemsModel? {
		do {
			let playlistItems = try await provider.getPlaylistItems(playlistId: playlistID)
			
			return playlistItems
		} catch {
			print("Error en PlaylistItems method")
			
			return nil
		}
	}
}
