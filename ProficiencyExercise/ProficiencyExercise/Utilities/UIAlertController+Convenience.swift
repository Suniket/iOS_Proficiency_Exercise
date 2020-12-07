//
//  UIAlertController+Convenience.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 7/12/20.
//

import UIKit

extension UIAlertController {

    static func buildAlertController(for model: AlertViewModel) -> UIAlertController {
        let controller = UIAlertController(title: model.title, message: model.message, preferredStyle: model.prefferedStyle)
        
        model.actionModels.forEach({ controller.addAction(UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler)) })
        
        return controller
    }
}
