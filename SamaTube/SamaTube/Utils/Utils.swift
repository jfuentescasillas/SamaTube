//
//  Utils.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 21/02/23.
//
// This file reads a JSON and converts it into a specific type of data


import Foundation


class Utils {
	static func parseJSON<T: Decodable>(jsonName: String, model: T.Type) -> T? {
		guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
			return nil
		}
		
		do {
			let data = try Data(contentsOf: url)
			let jsonDecoder = JSONDecoder()
			
			do {
				let responseModel = try jsonDecoder.decode(T.self, from: data)
				
				return responseModel
			} catch {
				print("JSON Mock error: \(error)")
				
				return nil
			}
			
		} catch {
			print("Some error in Mock: \(error)")
			
			return nil
		}
	}
}
