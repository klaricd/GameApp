//
//  GamesTableViewCell.swift
//  GameApp
//
//  Created by David Klaric on 08.02.2023..
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    
    var game: GameResults? {
        didSet {
            guard let game = game else { return }
            if let url = URL(string: game.background_image) {
                gameImage.kf.setImage(with: url)
            }
            gameName.text = game.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
