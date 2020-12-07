//
//  AlertModel.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import UIKit

/// Model to show data on alerts.
struct AlertViewModel {
    
    struct ActionModel: Equatable {
        
        var title: String?
        var style: UIAlertAction.Style
        var handler: ((UIAlertAction) -> ())?
        
        static func == (lhs: AlertViewModel.ActionModel, rhs: AlertViewModel.ActionModel) -> Bool {
            return lhs.title == rhs.title &&
                lhs.style == rhs.style
        }
    }
    
    var actionModels = [ActionModel]()
    
    var title: String?
    
    var message: String?
    
    var prefferedStyle: UIAlertController.Style
}

extension AlertViewModel: Equatable {
    
    static func == (lhs: AlertViewModel, rhs: AlertViewModel) -> Bool {
        return lhs.title == rhs.title &&
        lhs.actionModels == rhs.actionModels &&
        lhs.message == rhs.message &&
        lhs.prefferedStyle == rhs.prefferedStyle
    }
    
    
}
