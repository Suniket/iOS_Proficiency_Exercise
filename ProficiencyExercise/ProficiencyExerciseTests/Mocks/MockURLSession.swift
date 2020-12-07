//
//  MockURLSession.swift
//  ProficiencyExerciseTests
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import Foundation
@testable import ProficiencyExercise

//MARK: MOCK
class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func successHttpURLResponse(url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        completionHandler(nextData, successHttpURLResponse(url: url), nextError)
        return nextDataTask
    }
    


}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
