//
//  NetworkManagerTests.swift
//  ProficiencyExerciseTests
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import XCTest
import Foundation
@testable import ProficiencyExercise

class NetworkManagerTests: XCTestCase {
    
    var testObject: NetworkManager!
    
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        testObject = NetworkManager(session: session)
    }
    
    override func tearDown() {}
    
    func testLoadData() {
        //Given
        let expectedData = "{}".data(using: .utf8)
        let dataTask = MockURLSessionDataTask()
        var actualData: NetworkResponse<AboutCanadaDataResponse>?

        //When
        session.nextDataTask = dataTask
        session.nextData = expectedData
        
        testObject.loadData(from: "https://mockurl", type: AboutCanadaDataResponse.self, withCompletion: { response in
            actualData = response
        })
        
        //Then
        XCTAssertNotNil(actualData)
        XCTAssert(dataTask.resumeWasCalled)
        
    }
    
}
