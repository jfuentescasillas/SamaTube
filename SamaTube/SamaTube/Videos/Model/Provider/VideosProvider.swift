//
//  VideosProvider.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//


import Foundation


protocol VideoProviderProtocol {
	func getVideos(channelID: String) async throws -> VideoModel
}


class VideosProvider: VideoProviderProtocol {
	func getVideos(channelID: String) async throws -> VideoModel {
		var queryParams: [String: String] = ["part": "snippet", "type": "video", "maxResults": "50"]
		
		if !channelID.isEmpty {
			queryParams["channelId"] = channelID
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
}
