//
//  RequestModel.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//

import Foundation


struct RequestModel {
	var baseURL: URLBase = .youtube
	let endPoint: EndPoints
	var queryItems: [String: String]?
	let httpMethod: HttpMethod = .GET
	
	
	func getURL() -> String {
		return baseURL.rawValue + endPoint.rawValue
	}
	
	
	enum HttpMethod: String {
		case GET
		case POST
	}
	
	
	enum EndPoints: String {
		case search 	   = "/search"
		case channels 	   = "/channels"
		case playlist 	   = "/playlists"
		case playlistItems = "/playlistItems"
		case videos		   = "/videos"
		case empty 		   = ""
	}
	
	
	enum URLBase: String {
		case youtube = "https://youtube.googleapis.com/youtube/v3"
		case google = "https://otherweb.com/v2"
	}
}
