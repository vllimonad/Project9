//
//  ViewController.swift
//  project7
//
//  Created by Vlad Klunduk on 14/08/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitionsToShow = [Petition]()
    var sortedPetitions = [Petition]()
    var allPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showAlertToSearchPetitions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCreditsAlert))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(data)
                return
            }
        }
        showError()
    }
    
    func parse(_ json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            petitionsToShow = allPetitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitionsToShow[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitionsToShow[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCreditsAlert(){
        let ac = UIAlertController(title: nil, message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showAlertToSearchPetitions(){
        let ac = UIAlertController(title: "Search for", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let message = ac?.textFields?[0].text else { return }
            self?.searchPetitions(message)
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func searchPetitions(_ message: String) {
        for petition in allPetitions {
            if petition.title.contains(message) || petition.body.contains(message) {
                sortedPetitions.append(petition)
            }
        }
        petitionsToShow = sortedPetitions
        tableView.reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showAllPetitions))
    }
    
    @objc func showAllPetitions(){
        petitionsToShow = allPetitions
        tableView.reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCreditsAlert))
    }
    
    
}

