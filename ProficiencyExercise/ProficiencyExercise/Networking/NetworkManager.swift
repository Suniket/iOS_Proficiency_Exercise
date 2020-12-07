//
//  NetworkManager.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import Foundation

/// Class to handle networking related activities.
class NetworkManager {
        
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func loadData<T>(from url: String, type: T.Type, withCompletion completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
        let url = URL(string: url)!
        let task = session.dataTask(url: url) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (NetworkResponse<T>) -> ()) {
        
        guard let error = error as NSError? else {
            
            guard let data = data else { return completion(.failure(.noJSONData)) }
            
            let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                return completion(.failure(.noJSONData))
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                
                if let responseData = try? JSONSerialization.data(withJSONObject: responseJSONDict) {
                    do {
                        let model = try JSONDecoder().decode(T.self, from: responseData)
                        return completion(.success(model))
                    } catch {
                        return completion(.failure(.unknown))
                    }
                }
            } catch {
                return completion(.failure(.unknown))
            }
            return completion(.failure(.unknown))
        }
        
        /// Errors
        switch error.code {
        case NSURLErrorBadURL, NSURLErrorUnsupportedURL:
            completion(.failure(.unhandled(error)))
            
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorInternationalRoamingOff:
            completion(.failure(.noInternetConnection))
            
        case NSURLErrorTimedOut:
            completion(.failure(.timedOut))
            
        default:
            completion(.failure(.unhandled(error)))
        }
    }
}
