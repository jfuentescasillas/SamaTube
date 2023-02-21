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
	case statusCodeError = "Ocurrió un error l consultar la API: Status code"
	case jsonDecoderError = "Error al extraer datos del JSON"
	case unauthorizedError
}
