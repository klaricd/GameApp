//
//  GamesTableViewController.swift
//  GameApp
//
//  Created by David Klaric on 04.02.2023..
//

import UIKit
import Kingfisher

class GamesTableViewController: UITableViewController {
    
    var gameResults: [GameResults] = []
    let storedArray = UserDefaults.standard.array(forKey: "selectedCells") as? [Int] ?? [Int]()
    var array: String = ""
    var urlWithParameters: String = ""
    var currentPage = 1
    var selectedCell = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        getData(page: currentPage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToList" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameDetailsViewController
                controller.id = gameResults[indexPath.row].id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GamesTableViewCell else { return UITableViewCell() }
        cell.game = gameResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gameResults.count - 3 {
            loadNextPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Functions
    func getData(page: Int) {
        guard let url = URL(string: createURL(forPage: page)) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            guard let json = try? JSONDecoder().decode(Game.self, from: data) else { return }

            if page == 1 {
                self.gameResults = json.results
            } else {
                self.gameResults.append(contentsOf: json.results)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    func loadNextPage() {
        currentPage += 1
        getData(page: currentPage)
    }
    
    func createURL(forPage: Int) -> String {
        let baseURL = "https://api.rawg.io/api/games?key=272eadaec95d470aa384544e0225123e&genres="
        let suggestedIDs = storedArray.map { String($0)}.joined(separator: ",")
        let page = "&page=\(forPage.description)"
        let sum = baseURL + suggestedIDs + page
        return sum
    }
}
