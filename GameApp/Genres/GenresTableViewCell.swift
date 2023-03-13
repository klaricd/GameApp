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
    
    func configure(with genre: GenresResults, selected: Bool) {
        genreName.text = genre.name
        genreGamesCount.text = "Games: \(genre.games_count)"
        if let url = URL(string: genre.image_background) {
            genreImage.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
