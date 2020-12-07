//
//  MainViewModelTests.swift
//  ProficiencyExerciseTests
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import XCTest
import Foundation
@testable import ProficiencyExercise

class MainViewModelTests: XCTestCase {
    
    var testObject: MainViewModel!
    
    var delegate: MockMainViewModelDelegate!
    
    override func setUp() {
        testObject = MainViewModel()
        
        delegate = MockMainViewModelDelegate()
        testObject.delegate = delegate
    }
    
    override func tearDown() {}
    
    func testViewControllerClass() {
        XCTAssertTrue(testObject.viewControllerClass == MainViewController.self)
    }
    
    func testRefresh() {
        
        //Given
        testObject.networkManager = NetworkManager(session: MockURLSession())
        
        //When
        testObject.refresh()
        
        //Then
        XCTAssertTrue(delegate.loadingStateDidChangeCount == 2)
        XCTAssertTrue(testObject.rowsArray.count == 0)
        XCTAssertTrue(testObject.errorAlertViewModel != nil)
        XCTAssertTrue(testObject.errorAlertViewModel == AlertViewModel(actionModels: [AlertViewModel.ActionModel(title: "OK", style: .cancel, handler: nil)],
                                                                       title: "Error",
                                                                       message: "No JSON data available.",
                                                                       prefferedStyle: .alert))
    }
}

class MockMainViewModelDelegate: MainViewModelDelegate {
    
    var loadingStateDidChangeCount = 0

    func viewModel(_ viewModel: MainViewModel, loadingStateDidChange isLoading: Bool) {
        loadingStateDidChangeCount += 1
    }
}
