//
//  GameDetailsViewController.swift
//  GameApp
//
//  Created by David Klaric on 07.02.2023..
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!
    @IBOutlet weak var gameWebsite: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameMovies: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    
    var details: Detail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storedCellID = UserDefaults.standard.integer(forKey: "selectedCell") as Int
        let url = "https://api.rawg.io/api/games/\(storedCellID)?key=272eadaec95d470aa384544e0225123e&"
        
        getData(from: url)
    }
    
    func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("something wnet wrong")
                return
            }
            
            var details: Detail?
            
            do {
                details = try JSONDecoder().decode(Detail.self, from: data)
            } catch {
                print(error)
            }
            
            guard let json = details else {
                return
            }
            
            DispatchQueue.main.async {
                self.gameName.text = json.name
                self.gameReleaseDate.text = json.released
                self.gameRating.text = String(json.rating)
                self.gameMovies.text = String(json.movies_count)
                self.gameDescription.text = json.description
                
                let text = json.website
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.link, value: URL(string: text)!, range: NSMakeRange(0, text.utf16.count))
                print(attributedString)
                self.gameWebsite.attributedText = attributedString
                self.gameWebsite.isUserInteractionEnabled = true
                self.gameWebsite.numberOfLines = 0
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                self.gameWebsite.addGestureRecognizer(tapGesture)
                
            }
            
            self.details = json
            
        }).resume()
    }
    
    
    // MARK: - Functions
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("tapped")
        let text = (sender.view as! UILabel).attributedText
        var range = NSRange(location: 0, length: text!.length)
        if let url = text!.attribute(.link, at: 0, effectiveRange: &range) as? URL {
            print("url")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
