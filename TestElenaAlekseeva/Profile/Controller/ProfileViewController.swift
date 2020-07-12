//
//  ProfileViewController.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/10/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    //var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = ProfileManager.shared.image
        nameLabel.text = ProfileManager.shared.name 
        genderLabel.text = ProfileManager.shared.gender
        ageLabel.text = "\(ProfileManager.shared.age) years"
        
        configureBackButton()
    }
    
    private func configureBackButton() {
        backButton.backgroundColor = .white
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.cornerRadius = 20
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

