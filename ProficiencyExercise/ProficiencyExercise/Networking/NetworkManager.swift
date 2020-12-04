//
//  NetworkManager.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import Foundation

class NetworkManager {
    
    static func loadData(withCompletion completion: @escaping (AboutCanadaDataResponse?) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
           
            let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                  print("could not convert data to UTF-8 format")
                  return
             }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                print(responseJSONDict)
                
                if let responseData = try? JSONSerialization.data(withJSONObject: responseJSONDict) {
                    let wrapper = try? JSONDecoder().decode(AboutCanadaDataResponse.self, from: responseData)
                    completion(wrapper)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
