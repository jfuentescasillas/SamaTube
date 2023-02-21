// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let videoModel = try? JSONDecoder().decode(VideoModel.self, from: jsonData)

// This model can also be considered as a SearchModel


import Foundation


// MARK: - VideoModel
struct VideoModel: Decodable {
	let kind: String?
	let items: [VideoItem]
	let pageInfo: VideoPageInfo?
}


// MARK: - Item
struct VideoItem: Decodable {
	let kind: String
	let id: String?
	let snippet: VideoSnippet?
	let contentDetails: VideoContentDetails?
	let statistics: VideoStatistics?
	
	
	enum CodingKeys: String, CodingKey {
		case kind
		case id
		case snippet
		case contentDetails
		case statistics
	}
	
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.kind = try container.decode(String.self, forKey: .kind)
		
		if let id = try? container.decode(VideoItemID.self, forKey: .id) {
			self.id = id.videoId
		} else {
			if let id = try? container.decode(String.self, forKey: .id) {
				self.id = id
			} else {
				self.id = nil
			}
		}
		
		if let snippet = try? container.decode(VideoSnippet.self, forKey: .snippet) {
			self.snippet = snippet
		} else {
			self.snippet = nil
		}
		
		if let contentDetails = try? container.decode(VideoContentDetails.self, forKey: .contentDetails) {
			self.contentDetails = contentDetails
		} else {
			self.contentDetails = nil
		}
		
		if let statistics = try? container.decode(VideoStatistics.self, forKey: .statistics) {
			self.statistics = statistics
		} else {
			self.statistics = nil
		}
	}
}


// MARK: - VideoItemID
struct VideoItemID: Decodable {
	let kind: String
	let videoId: String
}


// MARK: - ContentDetails
struct VideoContentDetails: Decodable {
	let duration, dimension, definition, caption: String?
	let licensedContent: Bool?
	let projection: String?
}


// MARK: - Snippet
struct VideoSnippet: Decodable {
	let publishedAt: String?
	let channelID, title, description: String?
	let thumbnails: VideoThumbnails?
	let channelTitle: String?
	let tags: [String]?
	
	enum CodingKeys: String, CodingKey {
		case publishedAt
		case channelID = "channelId"
		case title, description, thumbnails, channelTitle, tags
	}
}


// MARK: - Thumbnails
struct VideoThumbnails: Decodable {
	let medium, high: VideoDefault?
	
	
	enum CodingKeys: String, CodingKey {
		case medium, high
	}
}


// MARK: - Default
struct VideoDefault: Decodable {
	let url: String?
	let width, height: Int?
}


// MARK: - Statistics
struct VideoStatistics: Decodable {
	let viewCount, likeCount, favoriteCount, commentCount: String?
}


// MARK: - PageInfo
struct VideoPageInfo: Decodable {
	let totalResults, resultsPerPage: Int?
}
