//
//  PlaylistsItemsModel.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 17/02/23.
//


import Foundation


// MARK: - PlaylistsItemsModel
struct PlaylistItemsModel: Decodable {
	let kind: String
	let etag: String
	let items: [PlaylistItemsItem]
	let pageInfo: PlaylistItemsPageInfo
}


struct PlaylistItemsItem: Decodable {
	let kind: String
	let etag: String
	let id: String
	let snippet: VideoSnippet
	let contentDetails: PlaylistItemsContentDetails
}


struct PlaylistItemsPageInfo: Decodable {
	let totalResults: Int
	let resultsPerPage: Int
}


struct PlaylistItemsContentDetails: Decodable {
	let videoId: String?
	let videoPublishedAt: String?
}
