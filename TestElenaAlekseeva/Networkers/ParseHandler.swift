//
//  ParseHandler.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/10/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

class ParseHandler {  
    static func getData(completionHanndler: @escaping ([Person]) -> Void) {
        APIHandler.requestDataToAPI(urlString: Constants.urlString) { (data) in
            do {
                let people = try JSONDecoder().decode([Person].self, from: data)
                DispatchQueue.main.async {
                    completionHanndler(people)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
