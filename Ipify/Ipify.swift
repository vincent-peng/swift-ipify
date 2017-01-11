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
		case failure(Error)
	}
	
	enum CustomError: LocalizedError {
		case noData
		case parsingJson
		case unknown
		
		var errorDescription: String? {
			switch self {
			case .noData:
				return "There was no data on the server response."
			case .parsingJson:
				return "Error parsing the JSON file from the server."
			case .unknown:
				return "Unkown error."
			}
		}
	}
	
	
	public static func getPublicIPAddress(completion: @escaping CompletionHandler) {
		let url = URL(string: "https://api.ipify.org?format=json")!
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard error == nil else {
				if let error = error {
					completion(Result.failure(error))
				} else {
					completion(Result.failure(CustomError.unknown))
				}
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
				completion(Result.failure(CustomError.parsingJson))
			}
		}.resume()
	}
}
