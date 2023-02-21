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
	let items: [PlaylistItemsItems]
	let pageInfo: PlaylistItemsPageInfo
}


struct PlaylistItemsItems: Decodable {
	let kind: String
	let etag: String
	let id: String
	let snippet: VideoSnippet
}


struct PlaylistItemsPageInfo: Decodable {
	let totalResults: Int
	let resultsPerPage: Int
}
