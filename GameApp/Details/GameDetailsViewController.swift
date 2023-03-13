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
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = id else { return }
        let url = "https://api.rawg.io/api/games/\(id)?key=272eadaec95d470aa384544e0225123e&"
        getData(from: url)
    }
    
    deinit {
        print("Deinit Game details view controller")
    }
    
    func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("something wnet wrong")
                return
            }
            
            guard let json = try? JSONDecoder().decode(Detail.self, from: data) else { return }
            
            DispatchQueue.main.async {
                self.gameName.text = (json.name)
                
                if let date = self.dateFormat(date: json.released) {
                    self.gameReleaseDate.text = date
                } else {
                    print("Invalid date string")
                }
                
                self.gameRating.text = String(json.rating)
                self.gameMovies.text = String(json.movies_count)
                
                let data = Data(json.description.utf8)
                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    let options: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17, weight: .medium),
                                                                  .foregroundColor: UIColor.black]

                    let customString = NSAttributedString(string: attributedString.string, attributes: options)
                    self.gameDescription.attributedText = customString
                }
                
                let text = json.website
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.link, value: URL(string: text)!, range: NSMakeRange(0, text.utf16.count))
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
    func dateFormat(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else { return nil }
        dateFormatter.dateFormat = "MMMM d, yyyy"
        var formattedString = dateFormatter.string(from: date)
        formattedString.replaceSubrange(formattedString.startIndex...formattedString.startIndex, with: String(formattedString[formattedString.startIndex]).capitalized)
        return formattedString
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let text = (sender.view as! UILabel).attributedText
        var range = NSRange(location: 0, length: text!.length)
        if let url = text!.attribute(.link, at: 0, effectiveRange: &range) as? URL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
