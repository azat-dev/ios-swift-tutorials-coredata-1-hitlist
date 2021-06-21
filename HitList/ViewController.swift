//
//  ViewController.swift
//  HitList
//
//  Created by Azat Kaiumov on 21.06.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Can't fetch data. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    private func addPerson(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else {
            return
        }
        
        let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Can't save. \(error), \(error.userInfo)")
            return
        }
        
        people.append(person)
        
        let index = IndexPath(row: people.count - 1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New name",
            message: "Add a new name",
            preferredStyle: .alert
        )
        
        alert.addTextField()
        
        alert.addAction(.init(title: "Cancel", style: .cancel))
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            [weak self, weak alert] _ in
            
            guard
                let self = self,
                let text = alert?.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return
            }
            
            self.addPerson(name: text)
        })
        
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }
}
