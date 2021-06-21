//
//  ViewController.swift
//  HitList
//
//  Created by Azat Kaiumov on 21.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
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
            
            self.names.append(text)
            let index = IndexPath(row: self.names.count - 1, section: 0)
            self.tableView.insertRows(at: [index], with: .automatic)
        })
        
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
}
