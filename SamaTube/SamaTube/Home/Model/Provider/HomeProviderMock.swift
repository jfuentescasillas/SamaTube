//
//  HomeProviderMock.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 21/02/23.
//


import Foundation


class HomeProviderMock: HomeProviderProtocol {
	func getVideos(searchString: String, channelID: String) async throws -> VideoModel {
		guard let model = Utils.parseJSON(jsonName: "SearchVideos", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getChannel(channelID: String) async throws -> ChannelsModel {
		guard let model = Utils.parseJSON(jsonName: "Channel", model: ChannelsModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getPlaylists(channelID: String) async throws -> PlaylistModel {
		guard let model = Utils.parseJSON(jsonName: "Playlists", model: PlaylistModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel {
		guard let model = Utils.parseJSON(jsonName: "PlaylistItems", model: PlaylistItemsModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
}
