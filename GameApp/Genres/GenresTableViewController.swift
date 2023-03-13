//
//  GenresTableViewController.swift
//  GameApp
//
//  Created by David Klaric on 02.02.2023..
//

import UIKit
import Kingfisher

class GenresTableViewController: UITableViewController {
    
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    var genres: Genre?
    var selectedCells: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButtonOutlet.isHidden = true
        let url = "https://api.rawg.io/api/genres?key=272eadaec95d470aa384544e0225123e"
        getData(from: url)
    }
    
    deinit {
        print("Deinit Genre details view controller")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as? GenresTableViewCell else { return UITableViewCell() }
        
        let genre = genres?.results[indexPath.row]
        
        cell.configure(with: genre!, selected: selectedCells.contains(genre!.id))
        
        if selectedCells.contains(genre!.id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let genre = genres?.results[indexPath.row] {
            if selectedCells.contains(genre.id) {
                selectedCells.remove(at: selectedCells.firstIndex(of: genre.id)!)
            } else {
                selectedCells.append(genre.id)
            }
            UserDefaults.standard.set(selectedCells, forKey: "selectedCells")
            print("saved cell: \(selectedCells)")
            tableView.reloadData()
            hideDoneButton()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: - Functions
    func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            guard let json = try? JSONDecoder().decode(Genre.self, from: data) else { return }
            self.genres = json
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    func hideDoneButton() {
        if !selectedCells.isEmpty {
            doneButtonOutlet.isHidden = false
        } else {
            doneButtonOutlet.isHidden = true
        }
    }
    
    //MARK: - Button
    @IBAction func doneButton(_ sender: Any) {
        // perform segue depending on selected game genres and display games of selected genre
        performSegue(withIdentifier: "gameListVC", sender: self)
    }
}
