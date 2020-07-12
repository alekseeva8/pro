//
//  CollectionViewController.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/10/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var collectionView: UICollectionView
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var ageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reloadButton: UIButton!
    
    //var numberOfRow = 0
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var people = [Person]()
    
    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        configureLayout()
        collectionView.addSubview(activityIndicator)
        ActivityIndicator.configureLayout(of: activityIndicator, to: view)
        activityIndicator.startAnimating()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        
        getData()
    }
    
    private func getData() {
        ParseHandler.getData() { [weak self] (peopleAPI) in
            peopleAPI.forEach { (person) in
                self?.people.append(Person(name: person.name, gender: person.gender, age: person.age))
            }
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        people = [Person]()
        getData()    
    }
    
    @IBAction func ageSegmentedControlTapped(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0: 
            people = people.sorted {
                return $0.age < $1.age
            }
            collectionView.reloadData()
        case 1: 
            people = people.sorted {
                return $0.age > $1.age
            }
            collectionView.reloadData()
        default: break
        }
    }
    
    @IBAction func genderSegmentedControlTapped(_ sender: UISegmentedControl) {
        
        let segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0: 
            ParseHandler.getData() { [weak self] (peopleAPI) in
                guard let self = self else {return}
                peopleAPI.forEach { (person) in
                    self.people.append(Person(name: person.name, gender: person.gender, age: person.age))
                }
                self.activityIndicator.stopAnimating()
                self.people = self.people.filter {
                    $0.gender == "male"
                    } 
                self.collectionView.reloadData()
            }
        case 1: 
            ParseHandler.getData() { [weak self] (peopleAPI) in
                guard let self = self else {return}
                peopleAPI.forEach { (person) in
                    self.people.append(Person(name: person.name, gender: person.gender, age: person.age))
                }
                self.activityIndicator.stopAnimating()
                self.people = self.people.filter {
                    $0.gender == "female"
                    }
                self.collectionView.reloadData()
            }
        default: break
        }
    }
    
    private func configureLayout() {
        
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)     
    }
}

//MARK: - Data Source
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        
        cell.nameLabel.text = people[indexPath.row].name
        
        cell.genderLabel.text = "30 years"
        cell.imageView.image = UIImage(named: "female")
        switch people[indexPath.row].gender {
        case "male":
            cell.imageView.image = UIImage(named: "male")
        case "female":
            cell.imageView.image = UIImage(named: "female")
        default:
            cell.imageView.image = UIImage(named: "user")
        }
        return cell
    }
}

//MARK: - Delegate
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 20 - 20 - 10/2)/2
        return CGSize(width: itemWidth, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //numberOfRow = indexPath.row 
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let profileVC = storyboard.instantiateViewController(identifier: "profileVC") as? ProfileViewController else { return }
//        profileVC.name = people[indexPath.row].name
//        present(profileVC, animated: true, completion: nil)
        
        ProfileManager.shared.name = people[indexPath.row].name
        ProfileManager.shared.gender = people[indexPath.row].gender 
        ProfileManager.shared.age = people[indexPath.row].age 
        switch people[indexPath.row].gender {
        case "male":
            ProfileManager.shared.image = UIImage(named: "male") ?? UIImage()
        case "female":
            ProfileManager.shared.image = UIImage(named: "female") ?? UIImage()
        default:
            break
        }
        performSegue(withIdentifier: "collectionToProfileVC", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let profileVC = segue.destination as? ProfileViewController {
//            profileVC.name = people[numberOfRow].name
//    }
//    }
}

