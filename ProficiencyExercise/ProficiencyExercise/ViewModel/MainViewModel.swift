//
//  MainViewModel.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import UIKit
import Foundation

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
    
    private let networkManager: NetworkManagerInjecting
    
    /// Dependency injected..
    init(with networkManager: NetworkManagerInjecting) {
        self.networkManager = networkManager
    }

    /// Indicates whether the view is considered to be loading. The default is
    /// `false`. Setting this property automatically updates the delegate.
    var isLoading: Bool = false {
        didSet {
            if isLoading != oldValue {
                delegate?.viewModel(self, loadingStateDidChange: isLoading)
            }
        }
    }
    
    ///  Responsible to create ViewController class.
    private var viewControllerClass: UIViewController.Type {
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
 
    func makeViewController() -> UIViewController {
        let stepVCType = self.viewControllerClass
        let viewController: UIViewController
        viewController = (stepVCType as UIViewController.Type).init()
        return viewController
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
        
        networkManager.loadData(withCompletion: { [weak self] response in
            
            guard let response = response else {
                return
            }
            
            self?.title = response.title
            self?.rowsArray = response.rows
            
            for (index, rows) in (self?.rowsArray ?? []).enumerated() {
                if (rows.title == nil) && (rows.description == nil) && (rows.imageHref == nil) {
                    self?.rowsArray.remove(at: index)
                }
            }
            
            self?.isLoading = false
        })
    }
    
}
