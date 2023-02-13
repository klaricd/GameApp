//
//  GamesTableViewController.swift
//  GameApp
//
//  Created by David Klaric on 04.02.2023..
//

import UIKit
import Kingfisher

class GamesTableViewController: UITableViewController {
    
    var games: Game?
    let storedArray = UserDefaults.standard.array(forKey: "selectedCells") as? [Int] ?? [Int]()
    var array: String = ""
    var urlWithParameters: String = ""
    var currentPage = 1 // not using for now
    var finalURL = "" // not using yet
    var selectedCell = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        arrayToStrings()
        parametersURL()
        let url = urlWithParameters
        getData(from: url, page: currentPage)
        print("user defaults array gamesVC: \(storedArray)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(games?.results.count ?? 0, 20)
        //return games?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GamesTableViewCell {
            let game = games?.results[indexPath.row]
            
            cell.gameName.text = game?.name
            if let url = URL(string: game!.background_image) {
                cell.gameImage.kf.setImage(with: url)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = games?.results[indexPath.row].id ?? 0
        if selectedCell == selectedCell {
            UserDefaults.standard.set(selectedCell, forKey: "selectedCell")
            UserDefaults.standard.synchronize()
            print("selected cell id gamesVC: \(selectedCell)")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Functions
    func getData(from url: String, page: Int) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("something wnet wrong")
                return
            }
            
            var games: Game?
            do {
                games = try JSONDecoder().decode(Game.self, from: data)
            } catch {
                print(error)
            }
            
            guard let json = games else {
                return
            }
            
            self.games = json
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    func arrayToStrings() {
        let intArray = storedArray
        let stringArray = intArray.map { String($0) }
        array = stringArray.joined(separator: ",")
        print("stringArray: \(array)")
    }
    
    func parametersURL() {
        let url = "https://api.rawg.io/api/games?key=272eadaec95d470aa384544e0225123e&genres="
        urlWithParameters = url + array + "&page=\(currentPage)"
        print("link s parametrima gamesVC: \(urlWithParameters)")
        finalURL = urlWithParameters
    }
}
