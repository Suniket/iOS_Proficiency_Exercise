//
//  MainViewModel.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import UIKit
import Foundation

protocol MainViewModelDelegate: AnyObject {

    func viewModel(_ viewModel: MainViewModel, loadingStateDidChange isLoading: Bool)
    
}

class MainViewModel: NSObject {
    
    var rowsArray = [Rows]()

    var title: String?
    
    weak var delegate: MainViewModelDelegate?

    /// Indicates whether the view is considered to be loading. The default is
    /// `false`. Setting this property automatically updates the delegate.
    var isLoading: Bool = false {
        didSet {
            if isLoading != oldValue {
                delegate?.viewModel(self, loadingStateDidChange: isLoading)
            }
        }
    }
    
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
 
    func makeViewController() -> UIViewController {
        let stepVCType = self.viewControllerClass
        let viewController: UIViewController
        viewController = (stepVCType as UIViewController.Type).init()
        return viewController
    }
    
    func viewIsLoading() {
        isLoading = true
        loadCanadaData()
    }
}

extension MainViewModel {
    
    func loadCanadaData() {
        
        NetworkManager.loadData(withCompletion: { [weak self] response in
            
            guard let response = response else {
                return
            }
            
            self?.title = response.title
            self?.rowsArray = response.rows
            self?.isLoading = false
        })
    }

}
