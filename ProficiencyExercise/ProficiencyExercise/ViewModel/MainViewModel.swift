//
//  MainViewModel.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import UIKit
import Foundation

private let endpointBaseUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

protocol MainViewModelDelegate: AnyObject {
    
    /// Method to notify abouty loading state.
    /// - Parameters:
    ///   - viewModel: MainViewModel
    ///   - isLoading: Loading status
    func viewModel(_ viewModel: MainViewModel, loadingStateDidChange isLoading: Bool)
    
}

//ViewModel to show data on main screen.
class MainViewModel: NSObject {
    
    var rowsArray = [Rows]()

    var title: String?
    
    weak var delegate: MainViewModelDelegate?
    
    var errorAlertViewModel: AlertViewModel?

    var networkManager = NetworkManager(session: URLSession.shared)
    
    /// Indicates whether the view is considered to be loading. The default is
    /// `false`. Setting this property automatically updates the delegate.
    var isLoading: Bool = false {
        didSet {
            if isLoading != oldValue {
                delegate?.viewModel(self, loadingStateDidChange: isLoading)
            }
        }
    }
    
    ///  Responsible to return name of ViewController class.
    var viewControllerClass: UIViewController.Type {
        let className = NSStringFromClass(type(of: self))
        
        let possibleTypeName = className.replacingOccurrences(of: "ViewModel", with: "") + "ViewController"
        if let type = NSClassFromString(possibleTypeName) as? UIViewController.Type {
            return type
        }
        
        var typeNamesSearched = [possibleTypeName]
        
        if let rangeOfStep = className.range(of: "ViewController"),
            rangeOfStep.upperBound == className.endIndex,
            rangeOfStep.lowerBound > className.startIndex {
            let stepDroppedTypeName = String(className.dropLast(4) + "Controller")
            if let type = NSClassFromString(stepDroppedTypeName) as? UIViewController.Type {
                return type
            }
            typeNamesSearched.append(stepDroppedTypeName)
        }
        
        let typeNamesSearchedString = typeNamesSearched.joined(separator: " or ")
        assertionFailure("""
            No `UIViewController` found with the name '\(typeNamesSearchedString)`.
            """)
        
        return UIViewController.self
    }
    
    /// Refresh view.
    func refresh() {
        isLoading = true
        loadCanadaData()
    }
}

// MARK: - Networking
extension MainViewModel {
    
    func loadCanadaData() {
        
        networkManager.loadData(from: endpointBaseUrl, type: AboutCanadaDataResponse.self) { [weak self] response in
            
            switch response {
            case let .success(aboutCanadaDataResponse):
                
                self?.title = aboutCanadaDataResponse.title
                self?.rowsArray = aboutCanadaDataResponse.rows
                
                for (index, rows) in (self?.rowsArray ?? []).enumerated() {
                    if (rows.title == nil) && (rows.description == nil) && (rows.imageHref == nil) {
                        self?.rowsArray.remove(at: index)
                    }
                }
                
                self?.isLoading = false
                
            case let .failure(error):
            
                let alertViewModel = AlertViewModel(actionModels: [AlertViewModel.ActionModel(title: "OK", style: .cancel, handler: nil)],
                                                title: "Error",
                                                message: error.errorDescription,
                                                prefferedStyle: .alert)
            
                self?.errorAlertViewModel = alertViewModel
                self?.isLoading = false
                
            }
        }
    }
    
}
