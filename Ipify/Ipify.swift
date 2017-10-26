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
	
	/// A closure containing a `Result` enum.
	public typealias CompletionHandler = (Result) -> Void
	
	
	/// Used to represent whether request was successful or encountered an error.
	///
	/// - success: The request was successful resulting. The associated value is the IP address string representation.
	/// - failure: The request encountered an error resulting in a failure. The associated values are the original data
	///            provided by the server as well as the error that caused the failure.
	public enum Result {
		case success(String)
		case failure(CustomError)
	}
	
	
	/// Custom error type which encompasses a few different types of errors, each with their own associated reasons.
	///
	/// - noData: Returned when no data received from server response.
	/// - invalidJson: Returned when JSON decoding process fails.
	/// - otherError: Returned default `Error`.
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
	
	
	/// Ipify service URL. Decleared as variable only for unit testabilty.
	internal(set) static var serviceURL = "https://api.ipify.org?format=json"
	
	
	/// Retrieve user's public IP address via ipify's API service.
	///
	/// - Parameter completion: The code to be executed once the request has finished.
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
