//
//  AboutCanadaDataResponse.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import Foundation

/// Response from server for data about Canada.
struct AboutCanadaDataResponse: Codable {
    
    let title: String?
    
    let rows: [Rows]

}

struct Rows: Codable {
    
    let title: String?
    
    let description: String?
    
    let imageHref: String?
}


