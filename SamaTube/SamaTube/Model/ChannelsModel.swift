//
//  ChannelsModel.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 17/02/23.
//


import Foundation


// MARK: - ChannelsModel
struct ChannelsModel: Decodable {
	let kind, etag: String?
	let pageInfo: ChannelsPageInfo?
	let items: [ChannelsItem]
}


// MARK: - Item
struct ChannelsItem: Decodable {
	let kind, id: String?
	let snippet: ChannelsSnippet?
	let statistics: ChannelsStatistics?
	let brandingSettings: ChannelsBrandingSettings?
}


// MARK: - BrandingSettings
struct ChannelsBrandingSettings: Decodable {
	let channel: Channel?
	let image: ChannelsImage?
}


// MARK: - Channel
struct Channel: Decodable {
	let title, description, keywords, defaultLanguage: String?
	let country: String?
}


// MARK: - Image
struct ChannelsImage: Decodable {
	let bannerExternalURL: String?

	
	enum CodingKeys: String, CodingKey {
		case bannerExternalURL = "bannerExternalUrl"
	}
}


// MARK: - Snippet
struct ChannelsSnippet: Decodable {
	let title, description, customURL, publishedAt: String?
	let thumbnails: ChannelsThumbnails?
	let defaultLanguage: String?
	let localized: ChannelsLocalized?
	let country: String?

	
	enum CodingKeys: String, CodingKey {
		case title, description
		case customURL = "customUrl"
		case publishedAt, thumbnails, defaultLanguage, localized, country
	}
}


// MARK: - Localized
struct ChannelsLocalized: Decodable {
	let title, description: String?
}


// MARK: - Thumbnails
struct ChannelsThumbnails: Decodable {
	let thumbnailsDefault, medium, high: ChannelsDefault?

	
	enum CodingKeys: String, CodingKey {
		case thumbnailsDefault = "default"
		case medium, high
	}
}


// MARK: - Default
struct ChannelsDefault: Decodable {
	let url: String?
	let width, height: Int?
}


// MARK: - Statistics
struct ChannelsStatistics: Decodable {
	let viewCount, subscriberCount: String?
	let hiddenSubscriberCount: Bool?
	let videoCount: String?
}


// MARK: - PageInfo
struct ChannelsPageInfo: Decodable {
	let totalResults, resultsPerPage: Int?
}
