//
//  HomePresenter.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 19/02/23.
//


import Foundation


protocol HomeViewProtocol: AnyObject {
	func getData(list: [[Any]])
}


class HomePresenter {
	var provider: HomeProviderProtocol
	weak var delegate: HomeViewProtocol?
	private var objectList = [[Any]]()
	
	init(delegate: HomeViewProtocol, provider: HomeProvider = HomeProvider()) {
		self.delegate = delegate
		self.provider = provider
	} 
	
	
	func getHomeObjects() async {
		objectList.removeAll()
		
		do {
//			let channels = try await provider.getChannel(channelID: Constants.channelID).items
			let playlist = try await provider.getPlaylists(channelID: Constants.channelID).items
//			let videos = try await provider.getVideos(searchString: "", channelID: Constants.channelID).items
			
			let playlistItems = try await provider.getPlaylistItems(playlistId: playlist.first?.itemId ?? "").items
			
//			objectList.append(channels)
//			objectList.append(videos)
			objectList.append(playlist)
			objectList.append(playlistItems)
			
		} catch {
			print(error)
		}
	}
}
