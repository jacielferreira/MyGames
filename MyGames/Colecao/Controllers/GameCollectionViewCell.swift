//
//  GameCollectionViewCell.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 18/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPlatform: UILabel!
    @IBOutlet weak var imCover: UIImageView!
    
    func prepare(with game: Game) {
        lbTitle.text = game.title ?? "-"
        if lbTitle.text == ""{
            lbTitle.text = "-"
        }
        lbPlatform.text = game.console?.name ?? "-"
        if let image = game.cover as? UIImage {
            imCover.image = image
        } else {
            imCover.image = UIImage(named: "noCover")
        }
    }
    
}
