//
//  HomeProvider.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 19/02/23.
//


import Foundation


// MARK: - Protocol
protocol HomeProviderProtocol {
	func getVideos(searchString: String, channelID: String) async throws -> VideoModel
	func getChannel(channelID: String) async throws -> ChannelsModel
	func getPlaylists(channelID: String) async throws -> PlaylistModel
	func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel
}


// MARK: - Main Class
class HomeProvider: HomeProviderProtocol {
	// MARK: Get Videos
	func getVideos(searchString: String, channelID: String) async throws -> VideoModel {
		var queryParams: [String: String] = ["part": "snippet", "type": "video"]
		
		if !channelID.isEmpty {
			queryParams["channelId"] = channelID
		}
		
		if !searchString.isEmpty {
			queryParams["q"] = searchString
		}
		
		let requestModel = RequestModel(endPoint: .search, queryItems: queryParams)
		
		do {
			let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
			
			return model
		} catch {
			print("Error getting videos: \(error)")
			
			throw error
		}
	}
	
	
	// MARK: Get Channel
	func getChannel(channelID: String) async throws -> ChannelsModel {
		let queryParams: [String: String] = ["part": "snippet,statistics,brandingSettings",
											 "id": channelID]
				
		let requestModel = RequestModel(endPoint: .channels, queryItems: queryParams)
		
		do {
			let model = try await ServiceLayer.callService(requestModel, ChannelsModel.self)
			
			return model
		} catch {
			print("Error getting Channel: \(error)")
			
			throw error
		}
	}
	
	
	// MARK: Get Playlists
	func getPlaylists(channelID: String) async throws -> PlaylistModel {
		let queryParams: [String: String] = ["part": "snippet,contentDetails",
											 "channelId": channelID]
				
		let requestModel = RequestModel(endPoint: .playlist, queryItems: queryParams)
		
		do {
			let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
			
			return model
		} catch {
			print("Error getting Playlists: \(error)")
			
			throw error
		}
	}
	
	
	// MARK: Get PlaylistItems
	func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel {
		let queryParams: [String: String] = ["part": "snippet,id,contentDetails",
											 "playlistId": playlistId]

		let requestModel = RequestModel(endPoint: .playlistItems, queryItems: queryParams)
		
		do{
			let model = try await ServiceLayer.callService(requestModel, PlaylistItemsModel.self)
			
			return model
		} catch {
			print("Error getting PlaylistsItems (ATTENTION: NOT PlayLists): \(error)")
			
			throw error
		}
	}
}
