//
//  PlayVideoProviderMock.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//


import Foundation


class PlayVideoProviderMock: PlayVideoProviderProtocol {
	var throwError: Bool = false
	
	
	func getVideo(_ videoID: String) async throws -> VideoModel {
		if throwError {
			throw NetworkError.genericError
		}
		
		guard let model = Utils.parseJSON(jsonName: "VideoOnlyOne", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getRelatedVideos(_ relatedToVideoID: String) async throws -> VideoModel {
		if throwError {
			throw NetworkError.genericError
		}
		
		guard let model = Utils.parseJSON(jsonName: "SearchVideos", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getChannel(_ channelID: String) async throws -> ChannelsModel {
		if throwError {
			throw NetworkError.genericError
		}
		
		guard let model = Utils.parseJSON(jsonName: "Channel", model: ChannelsModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
}
