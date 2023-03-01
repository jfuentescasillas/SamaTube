//
//  PlayVideoProviderMock.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 28/02/23.
//


import Foundation


class PlayVideoProviderMock: PlayVideoProviderProtocol {
	func getVideo(_ videoID: String) async throws -> VideoModel {
		guard let model = Utils.parseJSON(jsonName: "VideoOnlyOne", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getRelatedVideos(_ relatedToVideoID: String) async throws -> VideoModel {
		guard let model = Utils.parseJSON(jsonName: "SearchVideos", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
	
	
	func getChannel(_ channelID: String) async throws -> ChannelsModel {
		guard let model = Utils.parseJSON(jsonName: "Channel", model: ChannelsModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
}
