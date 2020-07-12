//
//  ActivityIndicator.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/11/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class ActivityIndicator {

    class func configureLayout(of activityIndicator: UIActivityIndicatorView, to view: UIView) {
        activityIndicator.color = .systemBlue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
}

