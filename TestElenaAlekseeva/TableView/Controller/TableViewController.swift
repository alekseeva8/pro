//
//  TableViewController.swift
//  TestElenaAlekseeva
//
//  Created by Elena Alekseeva on 7/10/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reloadButton: UIButton!
    
    //var numberOfRow = 0
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(activityIndicator)
        ActivityIndicator.configureLayout(of: activityIndicator, to: view)
        activityIndicator.startAnimating()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        
        ageSegmentedControl.selectedSegmentTintColor = .lightGray
        genderSegmentedControl.selectedSegmentTintColor = .lightGray
    }
    
    private func getData() {
        ParseHandler.getData() { [weak self] (peopleAPI) in
            peopleAPI.forEach { (person) in
                self?.people.append(Person(name: person.name, gender: person.gender, age: person.age))
            }
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        
        activityIndicator.startAnimating()
        ageSegmentedControl.selectedSegmentTintColor = .lightGray
        genderSegmentedControl.selectedSegmentTintColor = .lightGray
        ageSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.selectedSegmentIndex = 0
        people = [Person]()
        getData()
    }
    
    @IBAction func ageSegmentedControlTapped(_ sender: UISegmentedControl) {
        ageSegmentedControl.selectedSegmentTintColor = .white
        genderSegmentedControl.selectedSegmentTintColor = .lightGray
        
        let segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0: 
            people = people.sorted {
                return $0.age < $1.age
            }
            tableView.reloadData()
        case 1: 
            people = people.sorted {
                return $0.age > $1.age
            }
            tableView.reloadData()
        default: break
        }
    }
    
    @IBAction func genderSegmentedControlTapped(_ sender: UISegmentedControl) {
        genderSegmentedControl.selectedSegmentTintColor = .white
        ageSegmentedControl.selectedSegmentTintColor = .lightGray
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
                self.tableView.reloadData()
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
                self.tableView.reloadData()
            }
        default: break
        }
    }
}

//MARK: - Data Source
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = "\(people[indexPath.row].age) years"
        switch people[indexPath.row].gender {
        case "male":
            cell.imageView?.image = UIImage(named: "male")
        case "female":
            cell.imageView?.image = UIImage(named: "female")
        default:
            cell.imageView?.image = UIImage(named: "user")
        }
        return cell
    }
}

//MARK: - Delegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        performSegue(withIdentifier: "tableToProfileVC", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let profileVC = segue.destination as? ProfileViewController {
//            profileVC.name = people[numberOfRow].name
//    }
//    }
}

