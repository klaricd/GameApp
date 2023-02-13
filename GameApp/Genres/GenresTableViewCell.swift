//
//  GenresTableViewCell.swift
//  GameApp
//
//  Created by David Klaric on 07.02.2023..
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var genreGamesCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
