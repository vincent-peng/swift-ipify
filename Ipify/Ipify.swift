//
//  Ipify.swift
//  Ipify
//
//  Created by Vincent Peng on 1/10/17.
//  Copyright © 2017 Vincent Peng. All rights reserved.
//

import Foundation

public struct Ipify {
	
	public typealias JSONDictionary = [String: Any]
	public typealias CompletionHandler = (Result) -> Void
	
	public enum Result {
		case success(String)
		case failure(CustomError)
	}
	
	public enum CustomError: LocalizedError {
		case noData
		case invalidJson
		case otherError(Error)
		
		public var errorDescription: String? {
			switch self {
			case .noData:
				return "There was no data on the server response."
			case .invalidJson:
				return "Error parsing the JSON file from the server."
			case .otherError(let err):
				return err.localizedDescription
			}
		}
	}
	
	internal static var serviceURL = "https://api.ipify.org?format=json"	// var only for unit testabilty
	
	public static func getPublicIPAddress(completion: @escaping CompletionHandler) {
		let url = URL(string: Ipify.serviceURL)!
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			handleIpifyResponse(with: data, error: error, completion: completion)
		}.resume()
	}
	
	internal static func handleIpifyResponse(with data: Data?, error: Error?, completion: @escaping CompletionHandler) {
		guard error == nil else {
			completion(Result.failure(CustomError.otherError(error!)))
			return
		}
		guard let data = data else {
			completion(Result.failure(CustomError.noData))
			return
		}

		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary, let ip = json["ip"] as? String {
				completion(Result.success(ip))
			}
		} catch {
			completion(Result.failure(CustomError.invalidJson))
		}
	}
}
