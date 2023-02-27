//
//  VideosProviderMock.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 27/02/23.
//


import Foundation


class VideosProviderMock: VideoProviderProtocol {
	func getVideos(channelID: String) async throws -> VideoModel {
		guard let model = Utils.parseJSON(jsonName: "VideoList", model: VideoModel.self) else {
			throw NetworkError.jsonDecoderError
		}
		
		return model
	}
}
