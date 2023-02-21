//
//  PlaylistModel.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 17/02/23.
//


import Foundation


struct PlaylistModel: Decodable {
	let kind: String
	let etag: String
	let pageInfo: PlaylistPageInfo
	let items: [PlaylistItem]
}


struct PlaylistPageInfo: Decodable {
	let totalResults: Int
	let resultsPerPage: Int
}


struct PlaylistItem: Decodable {
	let kind: String
	let etag: String
	let itemId: String
	let snippet: PlaylistSnippet
	let contentDetails: PlaylistContentDetails
	
	
	private enum CodingKeys: String, CodingKey {
		case kind, etag, snippet, contentDetails
		case itemId = "id"
	}
}


struct PlaylistSnippet: Decodable {
	let publishedAt: String
	let channelId: String
	let title: String
	let description: String
	let thumbnails: PlaylistThumbnails
	let channelTitle: String
	let localized: PlaylistLocalized
}


struct PlaylistThumbnails: Decodable {
	let thumbnailDefault: PlaylistDefault
	let medium, high, standard, maxres: PlaylistDefault
	
	
	private enum CodingKeys: String, CodingKey {
		case thumbnailDefault = "default"
		case medium, high, standard, maxres
	}
}


struct PlaylistDefault: Decodable  {
	let defaultUrl: String
	let width: Int
	let height: Int
	
	
	private enum CodingKeys: String, CodingKey {
		case defaultUrl = "url"
		case width, height
	}
}


struct PlaylistLocalized: Decodable {
	let title: String
	let description: String
}


struct PlaylistContentDetails: Decodable {
	let itemCount: Int
}
