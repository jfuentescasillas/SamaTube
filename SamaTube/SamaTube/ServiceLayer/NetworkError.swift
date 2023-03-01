//
//  NetworkError.swift
//  SamaTube
//
//  Created by Jorge Fuentes Casillas on 18/02/23.
//


import Foundation


enum NetworkError: String, Error {
	case invalidURL
	case serializationFailed
	case genericError
	case couldNotDecodeData
	case httpResponseError
	case statusCodeError
	case jsonDecoderError
	case unauthorizedError
}


extension NetworkError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .invalidURL:
			return NSLocalizedString("Invalid URL", comment: "")
			
		case .serializationFailed:
			return NSLocalizedString("Error serializing body request", comment: "")
			
		case .genericError:
			return NSLocalizedString("Unknown error. Validate API-Key", comment: "")
			
		case .couldNotDecodeData:
			return NSLocalizedString("Error decoding data", comment: "")
			
		case .httpResponseError:
			return NSLocalizedString("Impossible to get HTTPURLResponse", comment: "")
			
		case .statusCodeError:
			return NSLocalizedString("Status code different of 200", comment: "")
			
		case .jsonDecoderError:
			return NSLocalizedString("Error reading JSON. Impossible to decode", comment: "")
			
		case .unauthorizedError:
			return NSLocalizedString("Session ended. Restart session.", comment: "")
		}
	}
}
