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
	let items: [PlaylistItems]
	let pageInfo: PageInfo
	
	
	struct PlaylistItems: Decodable {
		let kind: String
		let etag: String
		let id: String
		let snippet: VideoSnippet
	}
	
	
	struct PageInfo: Decodable{
		let totalResults: Int
		let resultsPerPage: Int
	}
}
