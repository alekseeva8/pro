//
//  ProfileManager.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/10/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class ProfileManager {
    
    static let shared = ProfileManager()
    var name = ""
    var gender = ""
    var age = 0
    var image = UIImage()
    
    private init() {
    }
}
