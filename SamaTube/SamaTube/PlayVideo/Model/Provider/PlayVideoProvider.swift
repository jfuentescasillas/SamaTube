//
//  PlayVideoProvider.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//


import Foundation


protocol PlayVideoProviderProtocol {
	func getVideo(_ videoID: String) async throws -> VideoModel
	func getRelatedVideos(_ relatedToVideoID: String) async throws -> VideoModel
	func getChannel(_ channelID: String) async throws -> ChannelsModel
}


class PlayVideoProvider: PlayVideoProviderProtocol {
	func getVideo(_ videoID: String) async throws -> VideoModel {
		let queryItems = ["id": videoID, "part": "snippet,contentDetails,status,statistics"]
		let request = RequestModel(endPoint: .videos, queryItems: queryItems)
		
		do {
			let model = try await ServiceLayer.callService(request, VideoModel.self)
			debugPrint(model)
			
			return model
		} catch {
			throw error
		}
	}
	
	
	func getRelatedVideos(_ relatedToVideoID: String) async throws -> VideoModel {
		let queryItems = ["relatedToVideoId": relatedToVideoID, "part": "snippet", "maxResults": "50", "type": "video"]
		let request = RequestModel(endPoint: .search, queryItems: queryItems)
		
		do {
			let model = try await ServiceLayer.callService(request, VideoModel.self)
			
			return model
		} catch {
			throw error
		}
	}
	
	
	func getChannel(_ channelID: String) async throws -> ChannelsModel {
		let queryItems = ["id": channelID, "part": "snippet,statistics"]
		let request = RequestModel(endPoint: .channels, queryItems: queryItems)
		
		do {
			let model = try await ServiceLayer.callService(request, ChannelsModel.self)
			
			return model
		} catch {
			throw error
		}
	}
}
