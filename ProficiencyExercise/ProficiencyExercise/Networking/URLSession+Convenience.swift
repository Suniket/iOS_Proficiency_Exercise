//
//  URLSession+Convenience.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import Foundation

/// URLSession protocol
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
    func dataTask(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}


extension URLSessionDataTask: URLSessionDataTaskProtocol {}
