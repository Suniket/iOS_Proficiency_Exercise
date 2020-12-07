//
//  NetworkResponse.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import Foundation

/// Errors returned from network request.
enum NetworkError: Error, Equatable {
    case noInternetConnection
    case timedOut
    case unhandled(_: NSError)
    case incompleteResponse
    case noJSONData
    case unknown
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "The current device has no internet connection available to make the request."
            
        case .timedOut:
            return "The network request timed out."
            
        case let .unhandled(error):
            return "An unhandled network error occured: \(error)"
            
        case .incompleteResponse:
            return "The response received parses but is incomplete."
            
        case .noJSONData:
            return "No JSON data available."
            
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
